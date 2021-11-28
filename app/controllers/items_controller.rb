class ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found_response

  def index
    if params[:user_id]
      user = find_user
      items = user.items
    else
      items = Item.all
    end
    render json: items, include: :user
  end

  def show
    item = Item.find(params[:id])
    render json: item, include: :user
  end

  def create
    user = find_user
    item = user.items.create(item_params)
    render json: item, status: :created
  end

  private

  def find_user
    User.find(params[:user_id])
  end

  def item_params
    params.permit(:name, :description, :price)
  end

  def record_not_found_response(issue)
      render json: { error: "#{issue.model} not found" }, status: :not_found
  end

end
