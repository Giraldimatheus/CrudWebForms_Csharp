using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Reflection.Emit;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Entrevista_s4e_crud
{
    public partial class Empresas : System.Web.UI.Page
    {
        WinformDBEntities db = new WinformDBEntities();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CarregarDados();
            }
        }

        private void CarregarDados()
        {
            var empresas = db.tblEmpresa.ToList();
            GridViewEmpresas.DataSource = empresas;
            GridViewEmpresas.DataBind();
        }


        protected void Button1_Click(object sender, EventArgs e)
        {

            try
            {
                tblEmpresa emp = new tblEmpresa();
                emp.Nome = TextBox1.Text;
                emp.CNPJ = TextBox2.Text;


                db.tblEmpresa.Add(emp);
                db.SaveChanges();


                Label4.Text = "Banco de dados atualizado!";
            }
            catch (Exception ex)
            {
                Label4.Text = "Dados em duplicidade ou inconsistentes.";
            }
            CarregarDados();

        }
        
        protected void GridViewEmpresas_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            GridViewRow row = GridViewEmpresas.Rows[e.RowIndex];
            string id = GridViewEmpresas.DataKeys[e.RowIndex].Value.ToString();

            GridViewEmpresas_Update(id, row);
        }

        private void GridViewEmpresas_Update(string idEmpresa, GridViewRow row)
        {
            TextBox txtNome = (TextBox)row.FindControl("txtNome");
            TextBox txtCnpj = (TextBox)row.FindControl("txtCnpj");

            var idConvertido = Convert.ToInt32(idEmpresa);
            var empresa = db.tblEmpresa.Where(p => p.Id == idConvertido).FirstOrDefault();

            empresa.Nome = txtNome.Text;
            empresa.CNPJ= txtCnpj.Text;

            db.Entry(empresa).State = System.Data.Entity.EntityState.Modified;
            db.SaveChanges();
            GridViewEmpresas.EditIndex = -1;
            CarregarDados();

        }

        protected void GridViewEmpresas_RowEditing (object sender, GridViewEditEventArgs e)
        {
            GridViewEmpresas.EditIndex = e.NewEditIndex;
            CarregarDados();
        }
        protected void GridViewEmpresas_RowCanceling(object sender, GridViewCancelEditEventArgs e)
        {
            GridViewEmpresas.EditIndex = -1;
            CarregarDados();
        }

        private void ExcluirEmpresa(string id)
        {
            var idConvertido = int.Parse(id);

            var empresa = db.tblEmpresa.Where(p => p.Id == idConvertido).FirstOrDefault();

            db.tblEmpresa.Remove(empresa);
            db.SaveChanges();

            CarregarDados();

        }

        protected void GridViewEmpresas_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            var id = GridViewEmpresas.DataKeys[e.RowIndex].Value.ToString();

            ExcluirEmpresa(id);
        }
        protected void btnFiltrar_Click(object sender, EventArgs e)
        {
            if (!String.IsNullOrEmpty(txtFiltroId.Text))
            {

                var idConvertido = int.Parse(txtFiltroId.Text);
                var empresa = db.tblEmpresa
                    .Where(p => p.Id == idConvertido)
                    .FirstOrDefault();
                GridViewEmpresas.DataSource = new List<tblEmpresa>() { empresa };
            }
            else if (!String.IsNullOrEmpty(txtFiltroNome.Text))
            {
                string nome = txtFiltroNome.Text;
                List<tblEmpresa> empresasFiltradas = db.tblEmpresa.Where(p => p.Nome.Equals(nome)).ToList();
                // Atualize a exibição dos dados na GridView com as pessoas filtradas
                GridViewEmpresas.DataSource = empresasFiltradas;
            }

            else
            {
                CarregarDados();
            }



            GridViewEmpresas.DataBind();
        }

    }
}