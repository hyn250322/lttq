using System.Windows.Forms;
using System;

namespace CoffeeManagement
{
    public partial class CustomMessageBox : Form
    {
        private bool result;

        public bool Result
        {
            get { return result; }
        }

        public CustomMessageBox(string message)
        {
            InitializeComponent();
            lblMessage.Text = message;
        }

        // Phương thức Show mới
        public static DialogResult Show(string message, out bool exportInvoice)
        {
            using (CustomMessageBox customMessageBox = new CustomMessageBox(message))
            {
                // Hiển thị hộp thoại và chờ người dùng chọn OK hoặc Cancel
                DialogResult dialogResult = customMessageBox.ShowDialog();

                // Nếu chọn OK, set exportInvoice thành true, ngược lại là false
                exportInvoice = dialogResult == DialogResult.OK;

                return dialogResult;
            }
        }

        private void BtnOK_Click(object sender, EventArgs e)
        {
            result = true;
            this.Close();
        }

        private void BtnCancel_Click(object sender, EventArgs e)
        {
            result = false;
            this.Close();
        }
    }
}
