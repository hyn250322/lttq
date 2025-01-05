using CoffeeManagement.DAL;
using System;
using System.Data;
using System.Windows.Forms;
using OfficeOpenXml;
using OfficeOpenXml.Style;
using System.IO;

namespace CoffeeManagement
{
    public partial class Bill : Form
    {
        #region Properties
        public int CurrentPage { get; set; }
        public int TotalPage { get; set; }
        #endregion
        #region System
        public Bill()
        {
            InitializeComponent();
        }

        private void Bill_Load(object sender, EventArgs e)
        {
            DateTime today = DateTime.Now;
            dtpFromDate.Value = new DateTime(today.Year, today.Month, 1);
            dtpToDate.Value = dtpFromDate.Value.AddMonths(1).AddDays(-1);

            btnStatistical_Click(null, null);
            btnFirstPage_Click(null, null);
            ShowBillByDateAndPage();
        }
        #endregion
        #region Common function
        private void ShowBillByDateAndPage()
        {
            txtCurrentPage.Text = CurrentPage + "/" + TotalPage;
            dgvBill.DataSource = BillDAL.Instance.GetBillByDateAndPage(dtpFromDate.Value, dtpToDate.Value, CurrentPage);
        }

        private void ChangeEnabledOfButtons()
        {
            btnFirstPage.Enabled = btnPrevPage.Enabled = true;
            btnLastPage.Enabled = btnNextPage.Enabled = true;

            if(CurrentPage == 1)
                btnFirstPage.Enabled = btnPrevPage.Enabled = false;
            if (CurrentPage == TotalPage)
                btnLastPage.Enabled = btnNextPage.Enabled = false;
        }
        #endregion
        #region Processing
        private void btnStatistical_Click(object sender, EventArgs e)
        {
            CurrentPage = 1;
            TotalPage = (int)Math.Ceiling(BillDAL.Instance.GetNumBillByDate(dtpFromDate.Value, dtpToDate.Value) / 10.0);
            btnFirstPage_Click(null, null);
        }

        private void lblExit_Click(object sender, EventArgs e)
        {
            this.Close();
        }
        #endregion
        #region Change page
        private void btnFirstPage_Click(object sender, EventArgs e)
        {
            CurrentPage = 1;
            ShowBillByDateAndPage();
            ChangeEnabledOfButtons();
        }

        private void btnPrevPage_Click(object sender, EventArgs e)
        {
            CurrentPage--;
            ShowBillByDateAndPage();
            ChangeEnabledOfButtons();
        }

        private void btnNextPage_Click(object sender, EventArgs e)
        {
            CurrentPage++;
            ShowBillByDateAndPage();
            ChangeEnabledOfButtons();
        }
        private void btnLastPage_Click(object sender, EventArgs e)
        {
            CurrentPage = TotalPage;
            ShowBillByDateAndPage();
            ChangeEnabledOfButtons();
        }
        #endregion


        private void btnExportStatiscal_Click(object sender, EventArgs e)
        {
            try
            {
                // Đặt LicenseContext cho EPPlus
                ExcelPackage.LicenseContext = LicenseContext.Commercial;

                SaveFileDialog saveFileDialog = new SaveFileDialog();
                saveFileDialog.Filter = "Excel Files|*.xlsx";
                saveFileDialog.Title = "Lưu báo cáo thống kê";
                saveFileDialog.FileName = "ThongKeHoaDon.xlsx";

                if (saveFileDialog.ShowDialog() == DialogResult.OK)
                {
                    string filePath = saveFileDialog.FileName;

                    using (ExcelPackage excelPackage = new ExcelPackage())
                    {
                        // Tạo một worksheet
                        ExcelWorksheet worksheet = excelPackage.Workbook.Worksheets.Add("Thống kê hóa đơn");

                        // Header
                        worksheet.Cells[1, 1].Value = "STT";
                        worksheet.Cells[1, 2].Value = "ID";
                        worksheet.Cells[1, 3].Value = "Tên bàn";
                        worksheet.Cells[1, 4].Value = "Ngày vào";
                        worksheet.Cells[1, 5].Value = "Ngày ra";
                        worksheet.Cells[1, 6].Value = "Giảm giá (%)";
                        worksheet.Cells[1, 7].Value = "Tổng tiền";

                        // Styling header
                        using (var range = worksheet.Cells[1, 1, 1, 7])
                        {
                            range.Style.Font.Bold = true;
                            range.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                            range.Style.Fill.PatternType = ExcelFillStyle.Solid;
                            range.Style.Fill.BackgroundColor.SetColor(System.Drawing.Color.LightBlue);
                        }

                        // Lấy tất cả hóa đơn từ BillDAL
                        var bills = BillDAL.Instance.GetListBillByDate(dtpFromDate.Value, dtpToDate.Value);

                        // Ghi dữ liệu vào file Excel
                        int rowIndex = 2;
                        for (int i = 0; i < bills.Rows.Count; i++)
                        {
                            worksheet.Cells[rowIndex, 1].Value = i + 1; // STT
                            worksheet.Cells[rowIndex, 2].Value = bills.Rows[i]["ID"]; // ID
                            worksheet.Cells[rowIndex, 3].Value = bills.Rows[i]["Tên bàn"]; // Tên bàn
                            worksheet.Cells[rowIndex, 4].Value = bills.Rows[i]["Ngày vào"]; // Ngày vào
                            worksheet.Cells[rowIndex, 5].Value = bills.Rows[i]["Ngày ra"]; // Ngày ra
                            worksheet.Cells[rowIndex, 6].Value = bills.Rows[i]["Giảm giá"]; // Giảm giá
                            worksheet.Cells[rowIndex, 7].Value = bills.Rows[i]["Tổng tiền"]; // Tổng tiền

                            // Định dạng ngày giờ cho cột "Ngày vào" và "Ngày ra"
                            worksheet.Cells[rowIndex, 4].Style.Numberformat.Format = "dd/MM/yyyy HH:mm:ss"; // Định dạng ngày giờ
                            worksheet.Cells[rowIndex, 5].Style.Numberformat.Format = "dd/MM/yyyy HH:mm:ss"; // Định dạng ngày giờ

                            rowIndex++;
                        }

                        // Lưu file
                        FileInfo excelFile = new FileInfo(filePath);
                        excelPackage.SaveAs(excelFile);
                    }

                    MessageBox.Show("Xuất dữ liệu thành công!", "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Information);
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Có lỗi xảy ra: {ex.Message}", "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }





    }
}
