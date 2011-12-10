class ItemsController < ApplicationController
  def new
    @item = Item.new
    respond_to do |format|
      format.html
    end
  end
  def create
    @item = Item.new(params[:item])
  end
end
