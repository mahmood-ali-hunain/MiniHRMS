using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

public partial class _Default : System.Web.UI.Page
{
    private readonly string connStr =
        ConfigurationManager.ConnectionStrings["MiniHRMSConnection"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadEmployees();
        }
    }

    private void LoadEmployees()
    {
        using (SqlConnection conn = new SqlConnection(connStr))
        using (SqlCommand cmd = new SqlCommand("sp_GetAllEmployees", conn))
        {
            cmd.CommandType = CommandType.StoredProcedure;

            SqlDataAdapter adapter = new SqlDataAdapter(cmd);
            DataTable table = new DataTable();
            adapter.Fill(table);

            gvEmployees.DataSource = table;
            gvEmployees.DataBind();
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;

        try
        {
            if (string.IsNullOrEmpty(hfEmployeeID.Value))
            {
                InsertEmployee();
                ShowMessage("Employee added successfully.", true);
            }
            else
            {
                UpdateEmployee(Convert.ToInt32(hfEmployeeID.Value));
                ShowMessage("Employee updated successfully.", true);
            }

            ClearForm();
            LoadEmployees();
        }
        catch (SqlException ex)
        {
            // SQL Server uses these numbers for unique constraint violations.
            if (ex.Number == 2627 || ex.Number == 2601)
                ShowMessage("This email already exists. Use a different email.", false);
            else
                ShowMessage("Database error: " + ex.Message, false);
        }
    }

    private void InsertEmployee()
    {
        using (SqlConnection conn = new SqlConnection(connStr))
        using (SqlCommand cmd = new SqlCommand("sp_InsertEmployee", conn))
        {
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.AddWithValue("@FullName",    txtFullName.Text.Trim());
            cmd.Parameters.AddWithValue("@Email",       txtEmail.Text.Trim());
            cmd.Parameters.AddWithValue("@Department",  ddlDepartment.SelectedValue);
            cmd.Parameters.AddWithValue("@Designation", txtDesignation.Text.Trim());
            cmd.Parameters.AddWithValue("@Salary",      Convert.ToDecimal(txtSalary.Text));
            cmd.Parameters.AddWithValue("@JoiningDate", Convert.ToDateTime(txtJoiningDate.Text));

            conn.Open();
            cmd.ExecuteNonQuery();
        }
    }

    private void UpdateEmployee(int employeeId)
    {
        using (SqlConnection conn = new SqlConnection(connStr))
        using (SqlCommand cmd = new SqlCommand("sp_UpdateEmployee", conn))
        {
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.AddWithValue("@EmployeeID",  employeeId);
            cmd.Parameters.AddWithValue("@FullName",    txtFullName.Text.Trim());
            cmd.Parameters.AddWithValue("@Email",       txtEmail.Text.Trim());
            cmd.Parameters.AddWithValue("@Department",  ddlDepartment.SelectedValue);
            cmd.Parameters.AddWithValue("@Designation", txtDesignation.Text.Trim());
            cmd.Parameters.AddWithValue("@Salary",      Convert.ToDecimal(txtSalary.Text));
            cmd.Parameters.AddWithValue("@JoiningDate", Convert.ToDateTime(txtJoiningDate.Text));

            conn.Open();
            cmd.ExecuteNonQuery();
        }
    }

    protected void gvEmployees_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "EditEmployee")
        {
            int id = Convert.ToInt32(e.CommandArgument);
            LoadEmployeeIntoForm(id);
        }
        else if (e.CommandName == "DeleteEmployee")
        {
            int id = Convert.ToInt32(e.CommandArgument);
            DeleteEmployee(id);
            ClearForm();
            LoadEmployees();
            ShowMessage("Employee deleted.", true);
        }
    }

    private void LoadEmployeeIntoForm(int employeeId)
    {
        using (SqlConnection conn = new SqlConnection(connStr))
        using (SqlCommand cmd = new SqlCommand("sp_GetEmployeeById", conn))
        {
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@EmployeeID", employeeId);

            conn.Open();
            using (SqlDataReader reader = cmd.ExecuteReader())
            {
                if (reader.Read())
                {
                    hfEmployeeID.Value     = reader["EmployeeID"].ToString();
                    txtFullName.Text       = reader["FullName"].ToString();
                    txtEmail.Text          = reader["Email"].ToString();
                    ddlDepartment.SelectedValue = reader["Department"].ToString();
                    txtDesignation.Text    = reader["Designation"].ToString();
                    txtSalary.Text         = Convert.ToDecimal(reader["Salary"]).ToString("0.##");
                    // Date inputs require the yyyy-MM-dd format.
                    txtJoiningDate.Text    = Convert.ToDateTime(reader["JoiningDate"]).ToString("yyyy-MM-dd");

                    lblFormTitle.Text = "Edit Employee";
                    btnSave.Text = "Update";
                    lblMessage.Text = "";
                }
            }
        }
    }

    private void DeleteEmployee(int employeeId)
    {
        using (SqlConnection conn = new SqlConnection(connStr))
        using (SqlCommand cmd = new SqlCommand("sp_DeleteEmployee", conn))
        {
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@EmployeeID", employeeId);

            conn.Open();
            cmd.ExecuteNonQuery();
        }
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        ClearForm();
        lblMessage.Text = "";
    }

    private void ClearForm()
    {
        hfEmployeeID.Value = "";
        txtFullName.Text = "";
        txtEmail.Text = "";
        ddlDepartment.SelectedIndex = 0;
        txtDesignation.Text = "";
        txtSalary.Text = "";
        txtJoiningDate.Text = "";
        lblFormTitle.Text = "Add New Employee";
        btnSave.Text = "Save";
    }

    private void ShowMessage(string text, bool success)
    {
        lblMessage.Text = text;
        lblMessage.ForeColor = success ? System.Drawing.Color.Green : System.Drawing.Color.Red;
    }
}
