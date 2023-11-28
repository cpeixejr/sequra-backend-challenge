class DisbursementsController < ApplicationController
  before_action :set_disbursement, only: %i[show edit update destroy]

  # GET /disbursements or /disbursements.json
  def index
    @disbursements = Disbursement.includes(:orders).page params[:page]
  end

  # GET /disbursements/1 or /disbursements/1.json
  def show; end

  # GET /disbursements/new
  def new
    @disbursement = Disbursement.new
  end

  # GET /disbursements/1/edit
  def edit; end

  # POST /disbursements or /disbursements.json
  def create
    @disbursement = Disbursement.new(disbursement_params)

    respond_to do |format|
      if @disbursement.save
        format.html { redirect_to disbursement_url(@disbursement), notice: 'Disbursement was successfully created.' }
        format.json { render :show, status: :created, location: @disbursement }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @disbursement.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /disbursements/1 or /disbursements/1.json
  def update
    respond_to do |format|
      if @disbursement.update(disbursement_params)
        format.html { redirect_to disbursement_url(@disbursement), notice: 'Disbursement was successfully updated.' }
        format.json { render :show, status: :ok, location: @disbursement }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @disbursement.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /disbursements/1 or /disbursements/1.json
  def destroy
    @disbursement.destroy!

    respond_to do |format|
      format.html { redirect_to disbursements_url, notice: 'Disbursement was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def annual_report
    @disbursements_count = Disbursement.unscope(:order).group_by_year(:reference_date).count
    @disbursements_amount = Disbursement.unscope(:order).group_by_year(:reference_date).sum(:amount)
    @disbursements_fees = Disbursement.unscope(:order).group_by_year(:reference_date).sum(:total_fee)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_disbursement
    @disbursement = Disbursement.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def disbursement_params
    params.fetch(:disbursement, {})
  end
end
