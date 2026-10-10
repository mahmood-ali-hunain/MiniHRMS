<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="_Default" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Mini HRMS</title>
    <style>
        body        { font-family: Segoe UI, Arial, sans-serif; background: #f4f6f9; margin: 0; }
        .container  { max-width: 1000px; margin: 30px auto; padding: 0 15px; }
        h1          { color: #1f3a5f; }
        .card       { background: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 1px 4px rgba(0,0,0,.12); margin-bottom: 25px; }
        .form-row   { margin-bottom: 12px; }
        .form-row label { display: inline-block; width: 120px; font-weight: 600; }
        .form-row input[type=text], .form-row input[type=email], .form-row input[type=date], .form-row select { width: 260px; padding: 6px; }
        .btn        { padding: 7px 18px; border: none; border-radius: 4px; cursor: pointer; color: #fff; }
        .btn-save   { background: #2e7d32; }
        .btn-cancel { background: #757575; }
        .error      { color: #c62828; font-size: 13px; }
        .message    { margin: 10px 0; font-weight: 600; }
        .grid       { width: 100%; border-collapse: collapse; }
        .grid th    { background: #1f3a5f; color: #fff; padding: 8px; text-align: left; }
        .grid td    { padding: 8px; border-bottom: 1px solid #ddd; }
        .grid tr:hover td { background: #f0f5ff; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <h1>Mini HRMS - Employee Management</h1>

            <div class="card">
                <h3><asp:Label ID="lblFormTitle" runat="server" Text="Add New Employee" /></h3>

                <!-- An empty ID means the form is adding a new employee. -->
                <asp:HiddenField ID="hfEmployeeID" runat="server" />

                <div class="form-row">
                    <label>Full Name</label>
                    <asp:TextBox ID="txtFullName" runat="server" MaxLength="100" />
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtFullName"
                        ErrorMessage="Required" CssClass="error" Display="Dynamic" />
                </div>

                <div class="form-row">
                    <label>Email</label>
                    <asp:TextBox ID="txtEmail" runat="server" MaxLength="150" />
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtEmail"
                        ErrorMessage="Required" CssClass="error" Display="Dynamic" />
                    <asp:RegularExpressionValidator runat="server" ControlToValidate="txtEmail"
                        ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$"
                        ErrorMessage="Invalid email" CssClass="error" Display="Dynamic" />
                </div>

                <div class="form-row">
                    <label>Department</label>
                    <asp:DropDownList ID="ddlDepartment" runat="server">
                        <asp:ListItem Text="-- Select --" Value="" />
                        <asp:ListItem>HR</asp:ListItem>
                        <asp:ListItem>IT</asp:ListItem>
                        <asp:ListItem>Finance</asp:ListItem>
                        <asp:ListItem>Sales</asp:ListItem>
                        <asp:ListItem>Marketing</asp:ListItem>
                        <asp:ListItem>Operations</asp:ListItem>
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="ddlDepartment"
                        InitialValue="" ErrorMessage="Select a department" CssClass="error" Display="Dynamic" />
                </div>

                <div class="form-row">
                    <label>Designation</label>
                    <asp:TextBox ID="txtDesignation" runat="server" MaxLength="100" />
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtDesignation"
                        ErrorMessage="Required" CssClass="error" Display="Dynamic" />
                </div>

                <div class="form-row">
                    <label>Salary</label>
                    <asp:TextBox ID="txtSalary" runat="server" />
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtSalary"
                        ErrorMessage="Required" CssClass="error" Display="Dynamic" />
                    <asp:CompareValidator runat="server" ControlToValidate="txtSalary"
                        Operator="DataTypeCheck" Type="Double"
                        ErrorMessage="Enter a number" CssClass="error" Display="Dynamic" />
                </div>

                <div class="form-row">
                    <label>Joining Date</label>
                    <asp:TextBox ID="txtJoiningDate" runat="server" TextMode="Date" />
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtJoiningDate"
                        ErrorMessage="Required" CssClass="error" Display="Dynamic" />
                </div>

                <asp:Button ID="btnSave" runat="server" Text="Save" CssClass="btn btn-save" OnClick="btnSave_Click" />
                <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn btn-cancel"
                    CausesValidation="false" OnClick="btnCancel_Click" />

                <div class="message"><asp:Label ID="lblMessage" runat="server" /></div>
            </div>

            <div class="card">
                <h3>All Employees</h3>
                <asp:GridView ID="gvEmployees" runat="server" CssClass="grid"
                    AutoGenerateColumns="false" DataKeyNames="EmployeeID"
                    EmptyDataText="No employees found."
                    OnRowCommand="gvEmployees_RowCommand">
                    <Columns>
                        <asp:BoundField DataField="EmployeeID"  HeaderText="ID" />
                        <asp:BoundField DataField="FullName"    HeaderText="Full Name" />
                        <asp:BoundField DataField="Email"       HeaderText="Email" />
                        <asp:BoundField DataField="Department"  HeaderText="Department" />
                        <asp:BoundField DataField="Designation" HeaderText="Designation" />
                        <asp:BoundField DataField="Salary"      HeaderText="Salary" DataFormatString="{0:N0}" />
                        <asp:BoundField DataField="JoiningDate" HeaderText="Joined" DataFormatString="{0:dd-MMM-yyyy}" />
                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>
                                <asp:LinkButton runat="server" Text="Edit" CommandName="EditEmployee"
                                    CommandArgument='<%# Eval("EmployeeID") %>' CausesValidation="false" />
                                &nbsp;|&nbsp;
                                <asp:LinkButton runat="server" Text="Delete" CommandName="DeleteEmployee"
                                    CommandArgument='<%# Eval("EmployeeID") %>' CausesValidation="false"
                                    OnClientClick="return confirm('Delete this employee?');" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </form>
</body>
</html>
