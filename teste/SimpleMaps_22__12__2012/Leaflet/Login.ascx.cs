﻿using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using MySql.Data.MySqlClient;
using System.Collections.Generic;


namespace Leaflet
{

    public partial class Login : System.Web.UI.UserControl
    {
        public bool logado;
        public string nomeSession = "";

        private void CarregaMapas(MySqlConnection conn, int id_usuario)
        {
            string sqlMapa = "SELECT * FROM tipo_mapa WHERE id_usuario = " + id_usuario;
            MySqlCommand command = new MySqlCommand(sqlMapa, conn);
            MySqlDataReader readerMapa = command.ExecuteReader();
            int old = ddlMapas.SelectedIndex;
            ddlMapas.Items.Clear();
            while (readerMapa.Read())
            {
                ddlMapas.Items.Add(readerMapa.GetString(2));
            }
            readerMapa.Close();
            if (old >= 0 && old < ddlMapas.Items.Count)
                ddlMapas.SelectedIndex = old;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            nomeSession = Session["login"] as string;
            if (nomeSession != null && nomeSession.Length > 0)
            {
                logado = true;
                lblLog.Text = "Bem vindo " + nomeSession;
                lblMsgLogin.Text = "";
                if (!IsPostBack)
                {
                    MySqlConnection conn = Conexao.criarConexao();
                    conn.Open();
                    CarregaMapas(conn, (int)Session["id"]);
                    conn.Close();
                    conn.Dispose();
                }
            }
            else
            {
                logado = false;
                lblLog.Text = "";
                lblMsgLogin.Text = "";
            }
        }

        protected void btnEntrar_Click(object sender, EventArgs e)
        {
            int id_usuario = 0;
            login objLogin = new login();
            bool retorno = objLogin.validaLogin(txtEmailLogin.Text, txtSenhaLogin.Text);

            if (retorno == true)
            {
                string usuario = "SELECT id_usuario, email FROM usuario WHERE email = '" + txtEmailLogin.Text + "'";
                MySqlConnection conn = Conexao.criarConexao();

                try
                {
                    DataSet connDataSet = new DataSet();
                    conn.Open();

                    MySqlCommand commandReader = new MySqlCommand(usuario, conn);
                    MySqlDataReader reader = commandReader.ExecuteReader();

                    while (reader.Read())
                        id_usuario = reader.GetUInt16(0);

                    reader.Close();

                    CarregaMapas(conn, id_usuario);

                    MySqlDataAdapter adapt = new MySqlDataAdapter(usuario,
                        "Server=dbmy0057.whservidor.com;Database=nunesespor_1;Uid=nunesespor_1;Pwd=a1b2c3;");

                    adapt.Fill(connDataSet, "usuarios");

                    string nome = Convert.ToString(connDataSet.Tables["usuarios"].Rows[0]["email"]);

                    logado = true;
                    Session["login"] = nome;
                    Session["id"] = id_usuario;
                    Session.Remove("nomeMapa");
                    Session.Remove("idMapa");
                    lblLog.Text = "Bem vindo " + nome;
                    lblMsgLogin.Text = "";

                }
                catch (Exception ex)
                {
                    lblMsgLogin.Text = "Ops, não foi possível acessar agora. Tente depois.";
                    try
                    {
                        System.Diagnostics.EventLog.WriteEntry("Home.aspx", ex.Message, System.Diagnostics.EventLogEntryType.Error);
                    }
                    catch { }
                }
                finally
                {
                    conn.Close();
                    conn.Dispose();
                }
            }
            else
            {
                lblMsgLogin.Text = "O email ou a senha estão incorretos.";
            }
        }

        public void abrirMapaSelecionado(object sender, EventArgs e)
        {
            // Ir para o Page Load
            string nomeMapa = ddlMapas.SelectedItem.Text;
            string a = nomeMapa.Replace(" ", "_");

            int id_mapa = 0;
            MySqlConnection conn = Conexao.criarConexao();
            try
            {
                conn.Open();
                CarregaMapas(conn, (int)Session["id"]);
                string query = "SELECT id_tipo_mapa FROM tipo_mapa WHERE nome = '" + nomeMapa + "'";
                MySqlCommand commandReader = new MySqlCommand(query, conn);
                MySqlDataReader reader = commandReader.ExecuteReader();
                while (reader.Read())
                    id_mapa = reader.GetUInt16(0);
                reader.Close();
            }
            catch { }
            finally
            {
                conn.Close();
                conn.Dispose();
            }
            (Page as Home).DefineInfoMapa(id_mapa, a);
        }
    }
}