module Api
  class MealsController < BaseController
    before_filter :load_meal, only: [:destroy, :show, :update]

    # GET /api/meals
    def index
      @meals = MealsQuery.new(params[:date_from], params[:date_to], params[:time_from], params[:time_to], current_user).query_with_order
    end

    # POST /api/meals
    def create
      @meal = current_user.meals.build(meal_params)
      if @meal.save
        render status: :created
      else
        render json: {errors: @meal.errors.full_messages}, status: :unprocessable_entity
      end
    end

    # DELETE /api/meals/:id
    def destroy
      @meal.destroy
      head :no_content
    end

    # GET /api/meals/:id
    def show
    end

    # PATCH /api/meals/:id
    def update
      @meal.update! meal_params
    end

    private

      def meal_params
        params.require(:meal).permit(:eaten_at, :description, :calories)
      end

      def load_meal
        @meal = current_user.meals.find(params[:id])
      end

  end
end