using DataProvider;
using System;
using System.Data;
using System.Data.SqlClient;
using System.Windows.Forms;

namespace CoffeeManagement.DAL
{
    public class BillInfoDAL : ConnectDB
    {
        #region Singleton pattern
        private static BillInfoDAL instance;
        public static BillInfoDAL Instance
        {
            get
            {
                if (instance == null)
                    instance = new BillInfoDAL();
                return instance;
            }
            private set { instance = value; }
        }

        private BillInfoDAL() { SQLQuery.Instance.connectionString = connect; }
        #endregion

        public DataTable GetBillInfoByIdBill(int id)
        {
            return SQLQuery.Instance.ExecuteQuery("SP_GetBillInfoByIdBill @idBill", new object[] { id });
        }

        public int InsertBillInfo(int idBill, int idTable, int amount, string note)
        {
            return SQLQuery.Instance.ExecuteNonQuery("SP_InsertBillInfo @idBill, @idTable, @amount, @note", new object[] { idBill, idTable, amount, note });
        }
        public bool DeleteBillInfo(int idBill, int idDrink)
        {
            string query = "DELETE FROM BillInfo WHERE IdBill = @idBill AND IdDrink = @idDrink";
            int result = SQLQuery.Instance.ExecuteNonQuery(query, new object[] { idBill, idDrink });
            return result > 0; // Trả về true nếu xóa thành công
        }


    }
}
