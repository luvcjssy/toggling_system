module Api
  module V1
    class ExportsController < BaseController
      before_action :authenticate_api_v1_user!

      def tracking
        workbook = FastExcel.open

        workbook = ExportService.new(workbook, current_api_v1_user, params[:class_ids], params[:school_ids]).tracking

        workbook.close

        send_data(
          workbook.read_string,
          disposition: 'attachment',
          type: 'application/excel',
          filename: "Tracking_Data.xlsx"
        )
      end
    end
  end
end