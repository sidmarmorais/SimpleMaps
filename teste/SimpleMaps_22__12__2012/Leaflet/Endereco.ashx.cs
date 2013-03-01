using System;
using System.Collections;
using System.Data;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Net;
using System.Xml;
using System.IO;
using System.Text;

namespace Leaflet
{
    /// <summary>
    /// Summary description for $codebehindclassname$
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    public class Endereco : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            WebResponse resp = null;
            Stream st = null;
            try
            {
                HttpWebRequest req = (HttpWebRequest)
                    HttpWebRequest.Create(
                    "http://maps.google.com/maps/api/geocode/xml?address=" +
                    HttpUtility.UrlPathEncode(context.Request.QueryString["end"]) +
                    "&sensor=false");
                req.Method = "GET";
                resp = req.GetResponse();
                st = resp.GetResponseStream();
                MemoryStream buf = new System.IO.MemoryStream(10240);
                byte[] tmp = new byte[1024];
                int len = 0;
                while ((len = st.Read(tmp, 0, 1024)) > 0)
                {
                    buf.Write(tmp, 0, len);
                }
                st.Close();
                st.Dispose();
                resp.Close();
                tmp = null;
                st = null;
                resp = null;

                buf.Seek(0, SeekOrigin.Begin);
                XmlReader r = XmlReader.Create(buf);
                StringBuilder enderecos = new StringBuilder(1024);
                enderecos.Append("([");
                bool virg = false;
                bool firstResult = true;

                while (r.Read())
                {
                    if (r.NodeType == XmlNodeType.Element && r.Name.Equals("result"))
                    {
                        if (firstResult)
                            firstResult = false;
                        else
                            enderecos.Append(",");
                        enderecos.Append("{");
                        virg = false;
                        while (r.Read())
                        {
                            if (r.NodeType == XmlNodeType.EndElement && r.Name.Equals("result"))
                            {
                                break;
                            }
                            else if (r.NodeType == XmlNodeType.Element && r.Name.Equals("formatted_address"))
                            {
                                while (r.Read())
                                {
                                    if (r.NodeType == XmlNodeType.Text)
                                    {
                                        if (virg) enderecos.Append(",");
                                        virg = true;
                                        enderecos.Append("formatted_address:\"");
                                        enderecos.Append(r.Value);
                                        enderecos.Append("\"");
                                        break;
                                    }
                                }
                            }
                            else if (r.NodeType == XmlNodeType.Element && r.Name.Equals("geometry"))
                            {
                                while (r.Read())
                                {
                                    if (r.NodeType == XmlNodeType.Element && r.Name.Equals("location"))
                                    {
                                        while (r.Read())
                                        {
                                            if (r.NodeType == XmlNodeType.EndElement && r.Name.Equals("location"))
                                            {
                                                break;
                                            }
                                            else if (r.NodeType == XmlNodeType.Element && r.Name.Equals("lat"))
                                            {
                                                while (r.Read())
                                                {
                                                    if (r.NodeType == XmlNodeType.Text)
                                                    {
                                                        if (virg) enderecos.Append(",");
                                                        virg = true;
                                                        enderecos.Append("lat:");
                                                        enderecos.Append(r.Value);
                                                        break;
                                                    }
                                                }
                                            }
                                            else if (r.NodeType == XmlNodeType.Element && r.Name.Equals("lng"))
                                            {
                                                while (r.Read())
                                                {
                                                    if (r.NodeType == XmlNodeType.Text)
                                                    {
                                                        if (virg) enderecos.Append(",");
                                                        virg = true;
                                                        enderecos.Append("lng:");
                                                        enderecos.Append(r.Value);
                                                        break;
                                                    }
                                                }
                                            }
                                        }
                                        break;
                                    }
                                }
                            }
                        }
                        enderecos.Append("}");
                    }
                }

                r.Close();
                buf.Close();
                buf.Dispose();

                enderecos.Append("])");

                context.Response.ContentType = "text/plain";
                context.Response.ContentEncoding = Encoding.UTF8;
                context.Response.BinaryWrite(Encoding.UTF8.GetBytes(enderecos.ToString()));
            }
            catch (Exception ex)
            {
                context.Response.ContentType = "text/plain";
                context.Response.ContentEncoding = Encoding.UTF8;
                context.Response.BinaryWrite(Encoding.UTF8.GetBytes("({error:\"" + ex.Message.Replace('\"', '\'') + "\"})"));
                if (st != null)
                {
                    st.Close();
                    st.Dispose();
                }
                if (resp != null)
                {
                    resp.Close();
                }
            }
        }

        public bool IsReusable
        {
            get
            {
                return true;
            }
        }
    }
}
