using System;
using System.Collections;
using System.ComponentModel;
using System.Data;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using MySql.Data.MySqlClient;
using System.Collections.Generic;

namespace Leaflet
{
    /// <summary>
    /// Summary description for WSPrincipal
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    [System.Web.Script.Services.ScriptService]
    public class WSPrincipal : System.Web.Services.WebService
    {

        [WebMethod]
        public string novoCadastro(string email, string senha, string rptSenha)
        {
            if (email.Length == 0)
            {
                return "Preencha o campo email.";
            }
            else if (rptSenha.Length == 0
                    || senha.Length == 0
                    || senha.Equals(rptSenha) == false)
            {
                return "Senha inválida.";
            }
            else
            {
                MySqlConnection conn = Conexao.criarConexao();

                try
                {
                    conn.Open();

                    MySqlCommand commandReader = new MySqlCommand(
                        "SELECT * FROM usuario WHERE EMAIL = \'" + email + "\'", conn);
                    MySqlDataReader reader = commandReader.ExecuteReader();
                    if (reader.HasRows == true)
                    {
                        return "E-mail já foi cadastrado.";
                    }
                    else
                    {
                        reader.Close();
                        MySqlCommand command = new MySqlCommand("insert into usuario values(\'\', \'" + email + "\', \'" + senha + "\')", conn);

                        command.ExecuteNonQuery();
                    }
                }
                catch { }
                finally
                {
                    conn.Close();
                    conn.Dispose();
                }
            }
            return "Cadastro realizado com sucesso!";
        }

        [WebMethod]
        public string MarcaPontoPersistencia(string lat, string lng, string texto, string id_mapa)
        {
            MySqlConnection conn = Conexao.criarConexao();

            try
            {
                conn.Open();
                MySqlCommand command = new MySqlCommand("insert into ponto values(\'\' ,\'" + lat + "\', \'" + lng + "\',\'" + texto + "\', " + id_mapa + ")", conn);
                command.ExecuteNonQuery();
            }
            catch { }
            finally
            {
                conn.Close();
                conn.Dispose();
            }
            return "Ponto marcado com sucesso!";
        }
        //Novo Mapa
        [WebMethod(EnableSession = true)]
        public string NovoMapa(string nome_mapa)
        {
            string nome = Session["login"] as string;
            int id_usuario = 0;

            MySqlConnection conn = Conexao.criarConexao();
            conn.Open();
            try
            {
                string sqlId = "SELECT id_usuario FROM usuario WHERE email = \'" + nome + "\'";
                MySqlCommand command = new MySqlCommand(sqlId, conn);

                MySqlDataReader reader = command.ExecuteReader();

                while (reader.Read())
                    id_usuario = reader.GetInt16(0);

                reader.Close();
                reader.Dispose();
            }
            catch { }
            //id_tipo_mapa
            //id_usuario
            //nome
            MySqlConnection conn2 = Conexao.criarConexao();
            try
            {
                conn2.Open();
                MySqlCommand command = new MySqlCommand("insert into tipo_mapa values(\'\' ,\'" + id_usuario.ToString() + "\', \'" + nome_mapa + "\')", conn);
                command.ExecuteNonQuery();
            }
            catch { }
            finally
            {
                // depois de cadastrar um novo mapa, deixa os campos de novo mapa invisiveis
                // nome_novo_mapa.Visible = false;
                //novo_mapa.Visible = false;
                conn2.Close();
                conn2.Dispose();
            }

            //***
            int id_tipo_mapa = 0;
            MySqlConnection conn3 = Conexao.criarConexao();

            conn3.Open();

            try
            {
                string query = "select id_tipo_mapa from tipo_mapa where id_usuario = \'" + id_usuario + "\' order by id_tipo_mapa desc limit 1";
                MySqlCommand command3 = new MySqlCommand(query, conn);

                MySqlDataReader reader3 = command3.ExecuteReader();

                while (reader3.Read())
                    id_tipo_mapa = reader3.GetInt16(0); // pega id do mapa que acabou de adicionar

                reader3.Close();
                reader3.Dispose();
            }
            catch { }
            finally
            {
                conn3.Close();
                conn3.Dispose();
            }
            return "Home.aspx?id_mapa=" + id_tipo_mapa.ToString();
        }

        //CARREGAR PONTOS MAPAS
        [WebMethod]
        public List<Ponto> CarregaInformacoes(string nomeMapa)// recebe nomeMapa do metodo carregarPonto
        {
             //nomeMapa = "KelvinMap";// testei isso para saber se a query está certa, mas não está

            // retirado do site http://www.macoratti.net/09/08/c_mysql1.htm
            using (MySqlConnection conn = Conexao.criarConexao())
            {
                using (MySqlCommand command = new MySqlCommand("SELECT ponto.* FROM ponto,tipo_mapa WHERE tipo_mapa.id_tipo_mapa = ponto.id_tipo_mapa AND tipo_mapa.nome = \'" + nomeMapa + "\'", conn)) // fazer isto funcionar
                {
                    List<Ponto> listaPontos = new List<Ponto>();
                    conn.Open();
                    using (MySqlDataReader dr = command.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            Ponto ponto = new Ponto();
                            ponto.id_ponto = Convert.ToInt32(dr["id_ponto"]);
                            ponto.latitude = dr["latitude"].ToString();
                            ponto.longitude = dr["longitude"].ToString();
                            ponto.texto = dr["texto"].ToString();
                            ponto.id_tipo_mapa = Convert.ToInt32(dr["id_tipo_mapa"]);
                            listaPontos.Add(ponto);
                        }
                        dr.Close();
                        dr.Dispose();
                        conn.Close();
                        conn.Dispose();
                        return listaPontos; // retorna lista de pontos
                    }
                }
            }
        }

        [WebMethod]
        public List<Triangulo> CarregarInfoTriangulo(string nomeMapa)
        {
            // retirado do site http://www.macoratti.net/09/08/c_mysql1.htm
            using (MySqlConnection conn = Conexao.criarConexao())
            {
                using (MySqlCommand command = new MySqlCommand("SELECT triangulo.* FROM triangulo,tipo_mapa WHERE tipo_mapa.id_tipo_mapa = triangulo.id_tipo_mapa AND tipo_mapa.nome = \'" + nomeMapa + "\'", conn)) // fazer isto funcionar
                {
                    List<Triangulo> listaTriangulo = new List<Triangulo>();
                    conn.Open();
                    using (MySqlDataReader reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            Triangulo t = new Triangulo();
                            t.id_triangulo = Convert.ToInt32(reader["id_triangulo"]);
                            t.texto = reader["texto"].ToString();
                            t.id_mapa = Convert.ToInt32(reader["id_tipo_mapa"]);
                            t.lat1 = reader["latitude1"].ToString();
                            t.lng1 = reader["longitude1"].ToString();
                            t.lat2 = reader["latitude2"].ToString();
                            t.lng2 = reader["longitude2"].ToString();
                            t.lat3 = reader["latitude3"].ToString();
                            t.lng3 = reader["longitude3"].ToString();
                            listaTriangulo.Add(t);
                        }
                        reader.Close();
                        reader.Dispose();
                        conn.Close();
                        conn.Dispose();
                        return listaTriangulo;
                    }
                }
            }
        }

        // 88888888888888888888888888888888\/
        [WebMethod]
        public List<Retangulo> CarregarInfoRetangulo(string nomeMapa)
        {
            using (MySqlConnection conn = Conexao.criarConexao())
            {
                using (MySqlCommand command = new MySqlCommand("SELECT poligno.* FROM poligno,tipo_mapa WHERE tipo_mapa.id_tipo_mapa = poligno.id_tipo_mapa AND tipo_mapa.nome = \'" + nomeMapa + "\'", conn))
                {
                    List<Retangulo> listaRetangulo = new List<Retangulo>();
                    conn.Open();
                    using (MySqlDataReader reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            Retangulo t = new Retangulo();
                            t.id_poligno = Convert.ToInt32(reader["id_poligno"]);
                            t.texto = reader["texto"].ToString();
                            t.id_mapa = Convert.ToInt32(reader["id_tipo_mapa"]);
                            t.lat1 = reader["latitude1"].ToString();
                            t.lng1 = reader["longitude1"].ToString();
                            t.lat2 = reader["latitude2"].ToString();
                            t.lng2 = reader["longitude2"].ToString();
                            t.lat3 = reader["latitude3"].ToString();
                            t.lng3 = reader["longitude3"].ToString();
                            t.lat4 = reader["latitude4"].ToString();
                            t.lng4 = reader["longitude4"].ToString();
                            listaRetangulo.Add(t);
                        }
                        reader.Close();
                        reader.Dispose();
                        conn.Close();
                        conn.Dispose();
                        return listaRetangulo;
                    }
                }
            }
        }

        //CARREGAR VIDEOS
        [WebMethod]
        public List<Video> CarregarInfoVideo(string nomeMapa)// recebe nomeMapa do metodo carregarPonto
        {
            // retirado do site http://www.macoratti.net/09/08/c_mysql1.htm
            using (MySqlConnection conn = Conexao.criarConexao())
            {
                using (MySqlCommand command = new MySqlCommand("SELECT video.* FROM video,tipo_mapa WHERE tipo_mapa.id_tipo_mapa = video.id_tipo_mapa AND tipo_mapa.nome = \'" + nomeMapa + "\'", conn)) // fazer isto funcionar
                {
                    List<Video> listaVideos = new List<Video>();
                    conn.Open();
                    using (MySqlDataReader dr = command.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            Video video = new Video();
                            video.id_ponto = Convert.ToInt32(dr["id_video"]);
                            video.latitude = dr["latitude"].ToString();
                            video.longitude = dr["longitude"].ToString();
                            video.texto = dr["texto"].ToString();
                            video.id_tipo_mapa = Convert.ToInt32(dr["id_tipo_mapa"]);
                            video.video = dr["video"].ToString();
                            listaVideos.Add(video);
                        }
                        dr.Close();
                        dr.Dispose();
                        conn.Close();
                        conn.Dispose();
                        return listaVideos; // retorna lista de pontos
                    }
                }
            }
        }

        //CARREGAR IMAGENS
        [WebMethod]
        public List<Imagem> CarregarInfoImagem(string nomeMapa)// recebe nomeMapa do metodo carregarPonto
        {
            // retirado do site http://www.macoratti.net/09/08/c_mysql1.htm
            using (MySqlConnection conn = Conexao.criarConexao())
            {
                using (MySqlCommand command = new MySqlCommand("SELECT * FROM imagem,tipo_mapa WHERE tipo_mapa.id_tipo_mapa = imagem.id_tipo_mapa AND tipo_mapa.nome = \'" + nomeMapa + "\'", conn)) // fazer isto funcionar
                {
                    List<Imagem> listaImagens = new List<Imagem>();
                    conn.Open();
                    using (MySqlDataReader dr = command.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            Imagem imagem = new Imagem();
                            imagem.id_imagem = Convert.ToInt32(dr["id_imagem"]);
                            imagem.latitude = dr["latitude"].ToString();
                            imagem.longitude = dr["longitude"].ToString();
                            imagem.texto = dr["texto"].ToString();
                            imagem.id_tipo_mapa = Convert.ToInt32(dr["id_tipo_mapa"]);
                            imagem.imagem = dr["imagem"].ToString();
                            listaImagens.Add(imagem);
                        }
                        dr.Close();
                        dr.Dispose();
                        conn.Close();
                        conn.Dispose();
                        return listaImagens; // retorna lista de pontos
                    }
                }
            }
        }

        // 88888888888888888888888888888888888888

        [WebMethod]
        public ArrayList CarregarDDL(string nome)
        {
            MySqlConnection conn = Conexao.criarConexao();
            ArrayList a = new ArrayList();
            try
            {
                conn.Open();
                //MySqlCommand command = new MySqlCommand("SELECT * FROM tipo_mapa WHERE id_tipo_mapa = \'" + id_mapa + "\'", conn);
                
                MySqlCommand command = new MySqlCommand("SELECT * FROM tipo_mapa where id_usuario = (select id_usuario from usuario where email = \'"+ nome + "\')", conn);
                
                // SELECT * FROM tipo_mapa where id_usuario = (select id_usuario from tipo_mapa where id_tipo_mapa = 42)

                MySqlDataReader readerMapa = command.ExecuteReader();

                while (readerMapa.Read())
                {
                    a.Add(readerMapa.GetString(2));
                }

                readerMapa.Close();
            }
            catch { }
            finally
            {
                conn.Close();
                conn.Dispose();
            }
            return a;
        }


        [WebMethod]
        public string MarcaTrianguloPersistencia(string lat1, string lng1, string lat2, string lng2, string lat3, string lng3, string texto, string id_mapa)
        {

            MySqlConnection conn = Conexao.criarConexao();

            try
            {
                conn.Open();
                MySqlCommand command = new MySqlCommand("insert into triangulo values(\'\' ,\'" + lat1 + "\', \'" + lng1 + "\',\'" + texto + "\', " + id_mapa + ", \'" + lat2 + "\' , \'" + lng2 + "\', \'" + lat3 + "\', \'" + lng3 + "\')", conn);
                command.ExecuteNonQuery();
            }
            catch { }
            finally
            {
                conn.Close();
                conn.Dispose();
            }
            return "Área marcada com sucesso!";

        }
        //88888888888888888888888888888888888888888888888
        [WebMethod]
        public string MarcaRetanguloPersistencia(string lat1, string lng1, string lat2, string lng2, string lat3, string lng3, string lat4, string lng4, string texto, string id_mapa)
        {

            MySqlConnection conn = Conexao.criarConexao();

            try
            {
                conn.Open();
                MySqlCommand command = new MySqlCommand("insert into poligno values(\'\' ,\'" + lat1 + "\', \'" + lng1 + "\',\'" + texto + "\', " + id_mapa + ", \'" + lat2 + "\' , \'" + lng2 + "\', \'" + lat3 + "\', \'" + lng3 + "\', \'" + lat4 + "\', \'" + lng4 + "\')", conn);
                command.ExecuteNonQuery();
            }
            catch { }
            finally
            {
                conn.Close();
                conn.Dispose();
            }
            return "Área marcada com sucesso!";

        }

        [WebMethod]
        public string MarcaVideoPersistencia(string lat1, string lng1, string texto, string linkVideo, string id_mapa)
        {
            MySqlConnection conn = Conexao.criarConexao();

            try
            {
                conn.Open();
                MySqlCommand command = new MySqlCommand("insert into video values(\'\' ,\'" + lat1 + "\', \'" + lng1 + "\',\'" + texto + "\', " + id_mapa + ", \'" + linkVideo + "\')", conn);
                command.ExecuteNonQuery();
            }
            catch { }
            finally
            {
                conn.Close();
                conn.Dispose();
            }
            return "Vídeo inserido com sucesso!";

        }


        [WebMethod]
        public string MarcaImagemPersistencia(string lat1, string lng1, string texto, string linkImagem, string id_mapa)
        {
            MySqlConnection conn = Conexao.criarConexao();

            try
            {
                conn.Open();
                MySqlCommand command = new MySqlCommand("insert into imagem values(\'\' ,\'" + lat1 + "\', \'" + lng1 + "\',\'" + texto + "\', " + id_mapa + ", \'" + linkImagem + "\')", conn);
                command.ExecuteNonQuery();
            }
            catch { }
            finally
            {
                conn.Close();
                conn.Dispose();
            }
            return "Imagem inserida com sucesso!";

        }

        //88888888888888888888888888888888888888888888888
        /*
        
        [WebMethod]
        public string salvarImagem(string lat, string lng, string id_mapa)
        {
            MySqlConnection conn = Conexao.criarConexao();

            try
            {
                conn.Open();
                MySqlCommand command = new MySqlCommand("insert into imagem values(\'\', \'" + lat + "\', \'" + lng + "\',\'" + id_mapa + "\')", conn);
                command.ExecuteNonQuery();
            }
            catch { }
            finally
            {
                conn.Close();
                conn.Dispose();
            }
            return "Área marcada com sucesso!";

        }
        */
    }//fim
}
