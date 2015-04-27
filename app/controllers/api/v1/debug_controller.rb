class Api::V1::DebugController < ApplicationController
  skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }

  def index
    render :json => {success: true}
  end
end
