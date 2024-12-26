﻿using CoffeeManagement.DAL;
using Guna.UI2.WinForms;
using System;
using System.IO;
using iTextSharp.text;
using iTextSharp.text.pdf;
using System.Data;
using System.Drawing;
using System.Globalization;
using System.Windows.Forms;
using System.Drawing.Printing;
using System.Linq;
using System.Collections.Generic;
using System.Data.SqlClient;

namespace CoffeeManagement
{
    public partial class Main : Form
    {
        #region Properties
        public DataRow LoginAccount { get; set; }
        private string lastInvoiceFilePath = string.Empty;
        private PrintDocument printDocument1 = new PrintDocument();
        private PrintPreviewDialog printPreviewDialog1 = new PrintPreviewDialog();
        private int rowIndex = 0; // Biến chỉ mục dòng hiện tại để in
        private float totalPrice; // Tổng tiền thanh toán
        private string amount; // Số tiền người dùng nhập vào
        private string change; // Tiền thối lại

        #endregion
        #region System
        public Main(DataRow loginAccount)
        {
            InitializeComponent();
            LoginAccount = loginAccount;
            tsmiManage.Enabled = (LoginAccount["Access"].ToString() == "Admin");
            tsmiAccountProfile.Text += (LoginAccount["DisplayName"].ToString() == "")
                                            ? " (" + LoginAccount["Username"] + ")"
                                            : " (" + LoginAccount["DisplayName"] + ")";
        }

        private void Main_Load(object sender, EventArgs e)
        {
            LoadTable();
            LoadComboBoxDrink();
            LoadComboBoxTable();
        }
        #endregion
        #region Common function
        private void LoadTable()
        {
            DataTable dt = TableDAL.Instance.GetTable();

            fpnlTableList.Controls.Clear();
            foreach (DataRow item in dt.Rows)
            {
                Guna2Button btn = new Guna2Button();
                btn.FillColor = Color.Transparent;
                btn.Font = new System.Drawing.Font("Segoe UI", 9.75F);
                btn.ForeColor = Color.Black;
                btn.Image = (item["StatusTable"].ToString() == "Trống") ? Properties.Resources.coffee_null : Properties.Resources.coffee_cup;
                btn.ImageOffset = new Point(0, -15);
                btn.ImageSize = new Size(60, 60);
                btn.Size = new Size(Content.tableWidth, Content.tableHeight);
                btn.Tag = item;
                btn.Text = item["NameTable"] + "\n" + item["StatusTable"];
                btn.TextAlign = HorizontalAlignment.Left;
                btn.TextOffset = new Point(0, 30);
                btn.Click += Btn_Click;

                fpnlTableList.Controls.Add(btn);
            }
        }

        private void LoadComboBoxDrink()
        {
            cboCategory.DataSource = CategoryDAL.Instance.GetTable();
            cboCategory.DisplayMember = "NameCategory";
            cboCategory.ValueMember = "IdCategory";
            cboCategory_SelectedIndexChanged(null, null);
        }

        private void LoadComboBoxTable()
        {
            cboSwitchTable.DataSource = TableDAL.Instance.GetTable();
            cboSwitchTable.DisplayMember = "NameTable";
            cboSwitchTable.ValueMember = "IdTable";

            cboMergeTable.DataSource = TableDAL.Instance.GetTable();
            cboMergeTable.DisplayMember = "NameTable";
            cboMergeTable.ValueMember = "IdTable";
        }

        private void ShowBill(int id)
        {
            int idBill = BillDAL.Instance.GetUncheckBillIDByTableID(id);
            dgvBillInfo.DataSource = BillInfoDAL.Instance.GetBillInfoByIdBill(idBill);

            CultureInfo culture = new CultureInfo("vi-VN");
            //Thread.CurrentThread.CurrentCulture = culture; Áp dụng thay đổi cả Thread
            txtTotalPrice.Text = TotalPrice().ToString("c", culture);
        }

        private int TotalPrice()
        {
            int sum = 0;
            for (int i = 0; i < dgvBillInfo.RowCount; i++)
                sum += Convert.ToInt32(dgvBillInfo.Rows[i].Cells["Thành tiền"].Value);
            return sum;
        }

        private void LoadInsEditDel_Drink()
        {
            int id;
            if (!Int32.TryParse(cboCategory.SelectedValue.ToString(), out id))
                return;
            cboDrink.DataSource = DrinkDAL.Instance.GetDrinkByIdCategory(id);
            if (dgvBillInfo.Tag != null)
                ShowBill(Convert.ToInt32((dgvBillInfo.Tag as DataRow)["IdTable"]));
        }
        #endregion
        #region Menu strip
        private void tsmiBill_Click(object sender, EventArgs e)
        {
            Bill bill = new Bill();
            bill.ShowDialog();
        }

        private void tsmiTableDrink_Click(object sender, EventArgs e)
        {
            TableFood table = new TableFood();
            table.InsertTable += Table_InsertTable;
            table.UpdateTable += Table_UpdateTable;
            table.DeleteTable += Table_DeleteTable;
            table.ShowDialog();
        }

        private void tsmiCategory_Click(object sender, EventArgs e)
        {
            Category category = new Category();
            category.InsertCategory += Category_InsertCategory;
            category.UpdateCategory += Category_UpdateCategory;
            category.DeleteCategory += Category_DeleteCategory;
            category.ShowDialog();
        }

        private void tsmiDrink_Click(object sender, EventArgs e)
        {
            Drink drink = new Drink();
            drink.InsertDrink += Drink_InsertDrink;
            drink.UpdateDrink += Drink_UpdateDrink;
            drink.DeleteDrink += Drink_DeleteDrink;
            drink.ShowDialog();
        }

        private void tsmiAccount_Click(object sender, EventArgs e)
        {
            Account account = new Account(LoginAccount);
            account.ShowDialog();
        }

        private void tsmiAccountProfile_Click(object sender, EventArgs e)
        {
            AccountProfile profile = new AccountProfile(LoginAccount);
            profile.UpdateAccount += Profile_UpdateAccount;
            profile.ShowDialog();
        }

        private void tsmiAddNumDrink_Click(object sender, EventArgs e)
        {
            btnAddNumDrink_Click(this, new EventArgs());
        }

        private void tsmiSwitchTable_Click(object sender, EventArgs e)
        {
            btnSwitchTable_Click(this, new EventArgs());
        }

        private void tsmiMergeTable_Click(object sender, EventArgs e)
        {
            btnMergeTable_Click(this, new EventArgs());
        }

        private void tsmiPayment_Click(object sender, EventArgs e)
        {
            btnPayment_Click(this, new EventArgs());
        }
        #endregion
        #region Event Handler
        private void Profile_UpdateAccount(object sender, AccountEvent e)
        {
            LoginAccount = e.LoginAcc;
            tsmiAccountProfile.Text = (LoginAccount["DisplayName"].ToString() == "")
                                            ? "&Thông tin tài khoản (" + LoginAccount["Username"] + ")"
                                            : "&Thông tin tài khoản (" + LoginAccount["DisplayName"] + ")";
        }

        private void Table_InsertTable(object sender, EventArgs e)
        {
            LoadTable();
        }

        private void Table_UpdateTable(object sender, EventArgs e)
        {
            LoadTable();
        }

        private void Table_DeleteTable(object sender, EventArgs e)
        {
            LoadTable();
        }

        private void Category_InsertCategory(object sender, EventArgs e)
        {
            LoadComboBoxDrink();
        }

        private void Category_UpdateCategory(object sender, EventArgs e)
        {
            LoadComboBoxDrink();
        }

        private void Category_DeleteCategory(object sender, EventArgs e)
        {
            LoadComboBoxDrink();
        }

        private void Drink_InsertDrink(object sender, EventArgs e)
        {
            LoadInsEditDel_Drink();
        }

        private void Drink_UpdateDrink(object sender, EventArgs e)
        {
            LoadInsEditDel_Drink();
        }

        private void Drink_DeleteDrink(object sender, EventArgs e)
        {
            LoadInsEditDel_Drink();
            LoadTable();
        }
        #endregion
        #region Processing
        private void Btn_Click(object sender, EventArgs e)
        {
            DataRow row = (sender as Guna2Button).Tag as DataRow;
            dgvBillInfo.Tag = (sender as Guna2Button).Tag;

            ShowBill(Convert.ToInt32(row["IdTable"]));
            grbSelectedTable.Text = row["NameTable"].ToString();
        }

        //private void btnPayment_Click(object sender, EventArgs e)
        //{
        //    DataRow row = dgvBillInfo.Tag as DataRow;

        //    int idBill = BillDAL.Instance.GetUncheckBillIDByTableID(Convert.ToInt32(row["IdTable"]));
        //    if (idBill != -1)
        //    {
        //        int discount = (int)nudDiscount.Value;
        //        int totalPrice = Convert.ToInt32(txtTotalPrice.Text.Split(',')[0].Replace(".", ""));
        //        int finalTotalPrice = totalPrice - (int)(totalPrice / 100 * discount);

        //        string msg = "Bạn có chắc chắn muốn thanh toán " + row["NameTable"] +
        //            "\nGiảm giá: " + discount + "%" +
        //            "\nTổng tiền = Tổng tiền - Giảm giá = " + totalPrice + " - " + (int)(totalPrice / 100 * discount) + " = " + finalTotalPrice;

        //        if (MessageBox.Show(msg, "Thanh toán", MessageBoxButtons.OKCancel, MessageBoxIcon.Question) == DialogResult.OK)
        //        {
        //            BillDAL.Instance.Payment(idBill, (int)nudDiscount.Value, finalTotalPrice);
        //            ShowBill(Convert.ToInt32(row["IdTable"]));
        //            LoadTable();
        //        }
        //    }
        //}

        private string CreateInvoicePDF(string paymentInfo)
        {
            // Đường dẫn lưu file PDF
            string filePath = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.Desktop), "HoaDon_" + DateTime.Now.ToString("yyyyMMdd_HHmmss") + ".pdf");

            using (FileStream fs = new FileStream(filePath, FileMode.Create))
            {
                Document document = new Document(PageSize.A4, 25, 25, 30, 30);
                PdfWriter.GetInstance(document, fs);

                document.Open();

                // Font tiếng Việt
                BaseFont bf = BaseFont.CreateFont(BaseFont.HELVETICA, BaseFont.CP1252, BaseFont.NOT_EMBEDDED);
                iTextSharp.text.Font font = new iTextSharp.text.Font(bf, 12);

                // Tiêu đề
                Paragraph title = new Paragraph("HÓA ĐƠN THANH TOÁN", new iTextSharp.text.Font(bf, 16, iTextSharp.text.Font.BOLD));
                title.Alignment = Element.ALIGN_CENTER;
                document.Add(title);

                // Khoảng cách
                document.Add(new Paragraph("\n"));

                // Nội dung hóa đơn
                string[] lines = paymentInfo.Split('\n');
                foreach (string line in lines)
                {
                    document.Add(new Paragraph(line, font));
                }

                // Đóng tài liệu
                document.Close();
            }

            return filePath;
        }


        private void btnPayment_Click(object sender, EventArgs e)
        {
            DataRow row = dgvBillInfo.Tag as DataRow;

            int idBill = BillDAL.Instance.GetUncheckBillIDByTableID(Convert.ToInt32(row["IdTable"]));
            if (idBill != -1)
            {
                int discount = (int)nudDiscount.Value;
                int totalPrice = Convert.ToInt32(txtTotalPrice.Text.Split(',')[0].Replace(".", ""));
                int finalTotalPrice = totalPrice - (int)(totalPrice / 100 * discount);

                // Nhập số tiền nhận từ người dùng
                string input = Microsoft.VisualBasic.Interaction.InputBox(
                    "Tổng tiền cần thanh toán: " + finalTotalPrice.ToString("N0") + " VND\nNhập số tiền khách đưa:",
                    "Thanh Toán",
                    "0");

                if (!int.TryParse(input, out int moneyReceived) || moneyReceived < finalTotalPrice)
                {
                    MessageBox.Show("Số tiền nhận không hợp lệ hoặc không đủ để thanh toán!", "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    return;
                }

                int moneyChange = moneyReceived - finalTotalPrice;

                string paymentInfo = "Tên bàn: " + row["NameTable"] +
                                     "\nTổng tiền: " + totalPrice.ToString("N0") + " VND" +
                                     "\nGiảm giá: " + discount + "%" +
                                     "\nTổng cộng: " + finalTotalPrice.ToString("N0") + " VND" +
                                     "\nTiền nhận: " + moneyReceived.ToString("N0") + " VND" +
                                     "\nTiền thối: " + moneyChange.ToString("N0") + " VND" +
                                     "\nNgày thanh toán: " + DateTime.Now.ToString("dd/MM/yyyy HH:mm:ss");

                // Thực hiện thanh toán
                BillDAL.Instance.Payment(idBill, discount, finalTotalPrice);
                ShowBill(Convert.ToInt32(row["IdTable"]));
                LoadTable();

                // Hiển thị thông báo và lấy lựa chọn của người dùng
                bool exportInvoice = false;
                if (MessageBox.Show(paymentInfo, "Thông báo", MessageBoxButtons.OKCancel) == DialogResult.OK)
                {
                    // Cập nhật thông tin cần in
                    this.totalPrice = finalTotalPrice;
                    this.amount = moneyReceived.ToString("N0");
                    this.change = moneyChange.ToString("N0");

                    // Cấu hình đối tượng PrintDocument và hiển thị hộp thoại xem trước
                    printDocument1.PrintPage += new PrintPageEventHandler(printDocument1_PrintPage);
                    printDocument1.BeginPrint += new PrintEventHandler(printDocument1_BeginPrint);

                    // Gán đối tượng PrintDocument cho PrintPreviewDialog
                    printPreviewDialog1.Document = printDocument1;

                    // Kiểm tra xem printPreviewDialog1 đã được cấu hình chưa
                    if (printPreviewDialog1.Document != null)
                    {
                        printPreviewDialog1.ShowDialog(); // Mở hộp thoại xem trước
                    }
                    else
                    {
                        MessageBox.Show("Không thể hiển thị hộp thoại xem trước. Kiểm tra cấu hình PrintDocument.", "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    }
                }
            }
        }




        private void printDocument1_BeginPrint(object sender, System.Drawing.Printing.PrintEventArgs e)
        {
            rowIndex = 0; // Khởi tạo lại chỉ mục dòng khi bắt đầu in
        }

        // Phương thức lấy dữ liệu và gán vào DataGridView
        private void LoadBillInfoIntoGrid(int idBill)
        {
            // Lấy dữ liệu từ cơ sở dữ liệu theo ID Bill
            DataTable billInfo = BillInfoDAL.Instance.GetBillInfoByIdBill(idBill);

            // Gán vào DataGridView
            dgvBillInfo.DataSource = billInfo;
        }
        private List<dynamic> GetBillDetails(int idBill)
        {
            string connectionString = "Data Source=DESKTOP-7TK4UNA\\SQLEXPRESS;" +
                                    "Initial Catalog=CoffeeManagement;" +
                                    "Integrated Security=True";
            string query = @"
        SELECT 
            Drink.NameDrink, 
            Drink.PriceDrink, 
            BillInfo.Amount, 
            (BillInfo.Amount * Drink.PriceDrink) AS TotalPrice
        FROM BillInfo
        INNER JOIN Drink ON BillInfo.IdDrink = Drink.IdDrink
        WHERE BillInfo.IdBill = @IdBill";

            var billDetails = new List<dynamic>();

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@IdBill", idBill);

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            billDetails.Add(new
                            {
                                NameDrink = reader["NameDrink"].ToString(),
                                PriceDrink = Convert.ToSingle(reader["PriceDrink"]),
                                Amount = Convert.ToInt32(reader["Amount"]),
                                TotalPrice = Convert.ToSingle(reader["TotalPrice"])
                            });
                        }
                    }
                }
            }

            return billDetails;
        }


        private void printDocument1_PrintPage(object sender, System.Drawing.Printing.PrintPageEventArgs e)
        { 
            int idBill = 1; // Thay bằng ID hóa đơn thực tế
            DataTable billDetails = BillDetailDAL.Instance.GetBillDetailsByIdBill(idBill);

            float y = e.MarginBounds.Top;
            int colWidth = 150;
            int rowHeight = 25;

            // Font
            System.Drawing.Font font = new System.Drawing.Font("Arial", 12);
            System.Drawing.Font boldFont = new System.Drawing.Font("Arial", 12, FontStyle.Bold);

            // Tiêu đề bảng
            e.Graphics.DrawString("Tên món", boldFont, Brushes.Black, e.MarginBounds.Left, y);
            e.Graphics.DrawString("Giá", boldFont, Brushes.Black, e.MarginBounds.Left + colWidth, y);
            e.Graphics.DrawString("Số lượng", boldFont, Brushes.Black, e.MarginBounds.Left + 2 * colWidth, y);
            e.Graphics.DrawString("Thành tiền", boldFont, Brushes.Black, e.MarginBounds.Left + 3 * colWidth, y);
            y += rowHeight;

            // In từng dòng chi tiết hóa đơn
            foreach (DataRow row in billDetails.Rows)
            {
                string nameDrink = row["NameDrink"].ToString();
                float priceDrink = Convert.ToSingle(row["PriceDrink"]);
                int amount = Convert.ToInt32(row["Amount"]);
                float totalPrice = Convert.ToSingle(row["TotalPrice"]);

                e.Graphics.DrawString(nameDrink, font, Brushes.Black, e.MarginBounds.Left, y);
                e.Graphics.DrawString(priceDrink.ToString("C2"), font, Brushes.Black, e.MarginBounds.Left + colWidth, y);
                e.Graphics.DrawString(amount.ToString(), font, Brushes.Black, e.MarginBounds.Left + 2 * colWidth, y);
                e.Graphics.DrawString(totalPrice.ToString("C2"), font, Brushes.Black, e.MarginBounds.Left + 3 * colWidth, y);
                y += rowHeight;
            }

            // Tổng cộng
            float totalAmount = billDetails.AsEnumerable()
                .Sum(row => Convert.ToSingle(row["TotalPrice"]));
            y += rowHeight;
            e.Graphics.DrawString($"Tổng cộng: {totalAmount.ToString("C2")}", boldFont, Brushes.Black, e.MarginBounds.Left, y);
        }






        private void btnAddNumDrink_Click(object sender, EventArgs e)
        {
            DataRow row = dgvBillInfo.Tag as DataRow;
            if (row == null)
            {
                MessageBox.Show("Hãy chọn bàn trước khi thêm đồ uống", "Quản lý", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            int idBill = BillDAL.Instance.GetUncheckBillIDByTableID(Convert.ToInt32(row["IdTable"]));
            int idDrink = Convert.ToInt32(cboDrink.SelectedValue);
            int amount = (int)nudNumDrink.Value;
            if (amount == 0) return;

            if (idBill == -1) // Bàn này chưa có bill
            {
                BillDAL.Instance.InsertBill(Convert.ToInt32(row["IdTable"]));
                BillInfoDAL.Instance.InsertBillInfo(BillDAL.Instance.GetMaxIDBill(), idDrink, amount);
            }
            else
                BillInfoDAL.Instance.InsertBillInfo(idBill, idDrink, amount);

            ShowBill(Convert.ToInt32(row["IdTable"]));
            LoadTable();
        }

        private void btnSwitchTable_Click(object sender, EventArgs e)
        {
            DataRow row = dgvBillInfo.Tag as DataRow;
            int id1 = Convert.ToInt32(row["IdTable"]);
            int id2 = Convert.ToInt32(cboSwitchTable.SelectedValue);

            DialogResult result = MessageBox.Show("Bạn có thật sự muốn chuyển từ " + row["NameTable"] + " sang " + cboSwitchTable.Text + " không?", "Chuyển bàn", MessageBoxButtons.OKCancel, MessageBoxIcon.Question);
            if (result == DialogResult.OK)
                TableDAL.Instance.SwitchTabel(id1, id2);
            LoadTable();
            ShowBill(id1);
        }

        private void btnMergeTable_Click(object sender, EventArgs e)
        {
            DataRow row = dgvBillInfo.Tag as DataRow;
            int id1 = Convert.ToInt32(row["IdTable"]);
            int id2 = Convert.ToInt32(cboMergeTable.SelectedValue);

            DialogResult result = MessageBox.Show("Bạn có thật sự muốn gộp từ " + row["NameTable"] + " sang " + cboMergeTable.Text + " không?", "Gộp bàn", MessageBoxButtons.OKCancel, MessageBoxIcon.Question);
            if (result == DialogResult.OK)
                TableDAL.Instance.MergeTable(id1, id2);
            LoadTable();
            ShowBill(id1);
        }

        private void lblExit_Click(object sender, EventArgs e)
        {
            this.Close();
        }
        #endregion

        private void cboCategory_SelectedIndexChanged(object sender, EventArgs e)
        {
            int id;
            if (!Int32.TryParse(cboCategory.SelectedValue.ToString(), out id))
                return;

            cboDrink.DataSource = DrinkDAL.Instance.GetDrinkByIdCategory(id);
            cboDrink.DisplayMember = "NameDrink";
            cboDrink.ValueMember = "IdDrink";
        }
    }
}
