package v0;
import java.rmi.Naming;
import java.rmi.registry.Registry;
import java.rmi.registry.LocateRegistry;
public class StartServerFTP {
	
	public static void main(String[] args)throws Exception{
		
		ServerFTP pt=new ServerFTP();
		
		Registry reg=LocateRegistry.createRegistry(5670);
		
		Naming.rebind("rmi://localhost:5670/FTPInterfaz", pt);
		System.out.println("FUNCIONA QUE BIEN");	
	}
	
}
