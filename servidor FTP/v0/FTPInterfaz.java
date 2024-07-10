package v0;

import java.rmi.Remote;
import java.rmi.RemoteException;

public interface FTPInterfaz extends Remote {
	FileList listFiles(String ruta) throws RemoteException;
	public String ImprimemeMiLista(FileList JuanAlberto)throws RemoteException;
	public void CreateFolder(String ruta,String name,String si)throws RemoteException;
	public void DeleteFolder(String ruta,String name)throws RemoteException;
	public byte [] downloadFile(String nomreArchivo,FileList lista,long offset,int resto) throws RemoteException;
	public void SubirArchivo(/*byte[] ,^*/String ArchivoSubirPC,FileList lista)throws RemoteException;
	
}
