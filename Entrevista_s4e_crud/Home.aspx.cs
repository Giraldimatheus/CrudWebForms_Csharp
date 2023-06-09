using System;
using System.Collections.Generic;
using System.Data.Entity.Migrations;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Services.Description;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Entrevista_s4e_crud
{
    public partial class Home : System.Web.UI.Page
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
            var funcionarios = db.tblPessoa.ToList();
            GridViewFuncionarios.DataSource = funcionarios;
            GridViewFuncionarios.DataBind();
            var empresas = db.tblEmpresa.ToList();
            Select1.DataSource = empresas;
            Select1.DataTextField = "Nome"; // Defina o nome da propriedade que será exibida como texto no dropdown
            Select1.DataValueField = "Id"; // Defina o nome da propriedade que será usada como valor no dropdown
            Select1.DataBind();
        }


        protected void Button1_Click(object sender, EventArgs e)
        {
            if (Select1.SelectedItem != null && Select1.SelectedItem.Value != "")
            {
                try
                {
                    tblPessoa p = new tblPessoa();

                    p.Nome = TextBox1.Text;
                    p.Cpf = TextBox2.Text;
                    p.DataNascimento = DateTime.Parse(TextBox3.Text);

                    db.tblPessoa.Add(p);
                    db.SaveChanges();

                    var UltimaPessoaCadastrada = db.tblPessoa
                        .ToList()
                        .LastOrDefault();

                    var funcionarioEmpresa = new List<tblPessoaEmpresa>();

                    // Percorre todas as empresas escolhidas na hora do cadastro
                    foreach (ListItem listItem in Select1.Items)
                    {
                        if (listItem.Selected)
                        {
                            var idConvertido = Convert.ToInt32(listItem.Value);
                            tblPessoaEmpresa PE = new tblPessoaEmpresa();
                            PE.tblPessoa_id = UltimaPessoaCadastrada.Id;
                            PE.tblEmpresa_id = idConvertido;

                            funcionarioEmpresa.Add(PE);
                        }
                    }

                    db.tblPessoaEmpresa.AddRange(funcionarioEmpresa);
                    db.SaveChanges();

                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "FecharModalScript", "fecharModal();", true);
                    CarregarDados();

                    label4.Text = "Banco de dados atualizado!";
                }
                catch (Exception ex)
                {
                    label4.Text = "Dados em duplicidade ou inconsistentes.";
                }
            }
            else
            {
                // Nenhuma empresa selecionada, exibir mensagem de erro ou tomar ação apropriada
                label4.Text = "Selecione pelo menos uma empresa antes de cadastrar.";
            }

            CarregarDados();
        }

        protected string GetEmpresasPessoa(object id)
        {
            int pessoaId = Convert.ToInt32(id);



            List<string> empresas = new List<string>();

            // Lógica para obter as empresas da pessoa pelo ID
            // Suponha que você tenha um método em seu repositório ou serviço para obter as empresas da pessoa
            empresas = db.tblPessoaEmpresa.Where(p => p.tblPessoa_id == pessoaId).Select(p => p.tblEmpresa.Nome).ToList();

            // Concatenar os nomes das empresas em uma única string separada por vírgulas
            string empresasConcatenadas = string.Join(", ", empresas);

            return empresasConcatenadas;
        }


        protected void CarregarEmpresas(object sender, EventArgs e)
        {
            Select1.Items.Clear();
            Select1.Items.Add(new ListItem("", ""));

            using (var db = new WinformDBEntities())
            {
                var empresas = db.tblEmpresa.ToList();

                foreach (var empresa in empresas)
                {
                    Select1.Items.Add(new ListItem(empresa.Nome, empresa.Id.ToString()));
                }
            }
        }

        protected void GridViewFuncionarios_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            GridViewRow row = GridViewFuncionarios.Rows[e.RowIndex];
            string id = GridViewFuncionarios.DataKeys[e.RowIndex].Value.ToString();

            GridViewFuncionarios_Update(id, row);
        }

        protected void GridViewFuncionarios_RowEditing(object sender, GridViewEditEventArgs e)
        {
            GridViewFuncionarios.EditIndex = e.NewEditIndex;
            CarregarDados();
        }

        protected void GridViewFuncionarios_RowCanceling(object sender, GridViewCancelEditEventArgs e)
        {
            GridViewFuncionarios.EditIndex = -1;
            CarregarDados();
        }

        private void GridViewFuncionarios_Update(string idFuncionario, GridViewRow row)
        {

            TextBox txtNome = (TextBox)row.FindControl("txtNome");
            TextBox txtCpf = (TextBox)row.FindControl("txtCpf");
            TextBox txtDataNascimento = (TextBox)row.FindControl("txtDataNascimento");



            var idConvertido = Convert.ToInt32(idFuncionario);
            var funcionario = db.tblPessoa.Where(p => p.Id == idConvertido).FirstOrDefault();
            funcionario.Nome = txtNome.Text;
            funcionario.Cpf = txtCpf.Text;
            funcionario.DataNascimento = DateTime.Parse(txtDataNascimento.Text);

            db.Entry(funcionario).State = System.Data.Entity.EntityState.Modified;
            db.SaveChanges();
            GridViewFuncionarios.EditIndex = -1;
            CarregarDados();

        }

        protected void GridViewFuncionarios_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            var id = GridViewFuncionarios.DataKeys[e.RowIndex].Value.ToString();

            ExcluiFuncionario(id);
        }

        private void ExcluiFuncionario(string id)
        {
            var idConvertido = int.Parse(id);

           

            var funcionarioEmpresa = db.tblPessoaEmpresa.Where(p => p.tblPessoa_id == idConvertido).FirstOrDefault();
            db.tblPessoaEmpresa.Remove(funcionarioEmpresa);
            db.SaveChanges();

            var funcionario = db.tblPessoa.Where(p => p.Id == idConvertido).FirstOrDefault();
            db.tblPessoa.Remove(funcionario);
            db.SaveChanges();
            
            CarregarDados();
        }

        protected void btnFiltrar_Click(object sender, EventArgs e)
        {

            if (!String.IsNullOrEmpty(txtFiltroId.Text))
            {

                var idConvertido = int.Parse(txtFiltroId.Text);
                var pessoa = db.tblPessoa
                    .Where(p => p.Id == idConvertido)
                    .FirstOrDefault();
                GridViewFuncionarios.DataSource = new List<tblPessoa>() { pessoa };
            }
            else if (!String.IsNullOrEmpty(txtFiltroNome.Text))
            {
                string nome = txtFiltroNome.Text;
                List<tblPessoa> pessoasFiltradas = db.tblPessoa.Where(p => p.Nome.Equals(nome)).ToList();
                // Atualize a exibição dos dados na GridView com as pessoas filtradas
                GridViewFuncionarios.DataSource = pessoasFiltradas;
            }

            else
            {
                 CarregarDados();
            }



            GridViewFuncionarios.DataBind();

        }


        protected void ctl15_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            
            ScriptManager.RegisterStartupScript(Page, Page.GetType(), "myModal", "$('#myModal').modal();", true);
            upModal.Update();
        }

        protected void Unnamed3_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        protected void ExibirModal()
        {
            string script = @"$(document).ready(function () {
                            $('#myModal').modal('show');
                        });";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "myModal", script, true);
        }
    }
}