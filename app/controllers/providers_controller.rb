class ProvidersController < ApplicationController
  def index
    @providers = Provider.order(updated_at: :desc)
  end

  def create
    provider_from_api = Provider.query(params[:npi])

    unless validate_npi
      flash[:error] = "NPI is invalid!"
      redirect_back fallback_location: nil and return
    end

    if provider_from_api.has_key?(:error)
      flash[:error] = provider_from_api[:error]
      redirect_back fallback_location: nil and return
    end

    provider = Provider.find_by(npi: provider_from_api[:npi])
    if provider.present?
      provider.touch(:updated_at)
      flash[:duplicated] = "Provider already there, put it to top!"
      redirect_back fallback_location: nil and return
    end

    if Provider.create(provider_from_api)
      flash[:create_success] = "Create Success!"
      redirect_back fallback_location: nil and return
    end
  end

  private 
  def validate_npi
    return params[:npi] =~ /^\d{10,11}$/
  end
end
