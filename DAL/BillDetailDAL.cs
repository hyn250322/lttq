using DataProvider;
using System.Data;

public class BillDetailDAL
{
    private static BillDetailDAL instance;

    public static BillDetailDAL Instance
    {
        get
        {
            if (instance == null)
                instance = new BillDetailDAL();
            return instance;
        }
        private set { instance = value; }
    }

    private BillDetailDAL() { }

    /// <summary>
    /// Lấy dữ liệu chi tiết hóa đơn từ IdBill
    /// </summary>
    /// <param name="idBill">ID hóa đơn</param>
    /// <returns>DataTable chứa chi tiết hóa đơn</returns>
    public DataTable GetBillDetailsByIdBill(int idBill)
    {
        string query = "SP_GetBillDetailsByIdBill @idBill";
        return SQLQuery.Instance.ExecuteQuery(query, new object[] { idBill });
    }
}
