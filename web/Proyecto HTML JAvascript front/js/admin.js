
//-----------------------------------Variables-----------------------------------//
const divMostrarInfoVideos = document.getElementById('info1');
const divMostrarInfoCategorias = document.getElementById("info2");
const divMostrarInfoUser= document.getElementById("info3");
const mostrarCategoria = document.getElementById("DataList");

const formCrearCategorias= document.getElementById("formCrearCategorias");
const formModificarCategorias= document.getElementById("formModificarCategorias");
const formEliminarCategorias= document.getElementById("formDeleteCategorias");

const formCrearVideos= document.getElementById("formCrearVideos");
const formModificarVideos= document.getElementById("formModificarVideos");
const formEliminarVideos= document.getElementById("formDeleteVideos");
// --------Div mostrar info-----------------//

const alerta = document.getElementById("alerta");
//userss
const mostrarUser1 = document.getElementById("DataListUser1");
const mostrarUser2 = document.getElementById("DataListUser2");
// categorias 
const mostrarCategoria1 = document.getElementById("DataListCategoria1");
const mostrarCategoria2 = document.getElementById("DataListCategoria2");

// videos 
const DataListCrearVideoMostrarCategoria=document.getElementById("DataListCrearVideoMostrarCategoria");
const mostrarVideoModificar = document.getElementById("datalistOptions3");
// --------Div mostrar info-----------------//
// users form
const formCrearUser= document.getElementById("formCrearUser");
const formModificarUser= document.getElementById("formModificarUser"); 
const formEliminarUser= document.getElementById("formDeleteUser");


const map1 = new Map();
// Definir constantes para URLs y selectores
const API_URL = "https://labingsoft.onrender.com/api/";
const VIDEOS_CONTAINER = document.getElementById("info");
const raw = JSON.stringify(); //esto ira cambiando segun lo que se quiera enviar
const token = localStorage.getItem("Token");
// al cargar la pagina se ejecutan las funciones

const  mapUser_ID = new Map();
const  mapCategoria_ID = new Map();
const  mapVideo_ID = new Map();

ComprobarToken();
function ComprobarToken() {
    if (!token) {
        alert("No has iniciado sesión. Por favor, inicia sesión para ver los videos");
        window.location.href = "index.html";
         
    }
}
 

const requestOptionsGET = {
    method: "GET",
    headers: new Headers({
        "Authorization": `Bearer ${token}`
    }),
    redirect: "follow"
};
const myHeaders = new Headers();
myHeaders.append("Content-Type", "application/json");
myHeaders.append("Authorization", `Bearer ${token}`);
const requestOptionsPUT = {
    method: "PUT",
    headers: myHeaders,
    body: raw,
    redirect: "follow"
  };
    /*
  const requestOptionsPOST = {
    method: "POST",
    headers: myHeaders,
    body: raw,
    redirect: "follow"
  };
  */
  const requestOptionsDELETE = {
    method: "DELETE",
    headers: myHeaders,
    redirect: "follow"
  };

 


  // crear tablas para mostrar y luego appendchild
 
 
 
  //-----------------------------------Funciones---- USUARIOS-------------------------------//
  
  var cont=1;
  async function deleteUsuarios() {
    
    if(cont%2==0){
     
      formEliminarUser.style.display = "none";
      cont++;
    }else{
  MostrarOption(mostrarUser2,mapUser_ID);
      formEliminarUser.style.display = "block";
    cont++;
    }
  }
 async function modificarUsuarios() {
 
    if(cont%2==0){
     
        formModificarUser.style.display = "none";
      cont++;
    }else{
      MostrarOption(mostrarUser1,mapUser_ID);
        formModificarUser.style.display = "block";
    cont++;
    }
  
 }
  async function crearUsuarios() {
         
    if(cont%2==0){
     
        formCrearUser.style.display = "none";
      cont++;
    }else{
    
        formCrearUser.style.display = "block";
    cont++;
    }
  }
  
  async function infoUsuarios() {

    // enlazar nombres y id de usuarios
    
    let tablas = document.createElement('table');
    tablas.className = 'table-hover';
    const tr = document.createElement('tr');
    tr.className = 'table-primary';

    const thNombre = document.createElement('th');
    thNombre.textContent = 'Nombre';
    tr.appendChild(thNombre);

    const thCorreo = document.createElement('th');
    thCorreo.textContent = 'Correo';
    tr.appendChild(thCorreo);

    const thRol = document.createElement('th');
    thRol.textContent = 'Rol';
    tr.appendChild(thRol);

    tablas.appendChild(tr);

    const response = await fetch('https://labingsoft.onrender.com/api/usuarios?limite=100&desde=0', requestOptionsGET);
    const data = await response.json();
    
    console.log(data);
    
    data.usuarios.forEach((usuario) => {
      mapUser_ID.set(usuario.nombre,usuario.uid);

        const tr = document.createElement('tr');
        tr.appendChild(document.createElement('td')).textContent = usuario.nombre;
        tr.appendChild(document.createElement('td')).textContent = usuario.correo;
        tr.appendChild(document.createElement('td')).textContent = usuario.rol;
        tablas.appendChild(tr);
    });
    console.log(mapUser_ID);
    divMostrarInfoUser.innerHTML = " ";
    
    let h3 = document.createElement("h3");
    h3.textContent = "Usuarios";
    h3.style.color="blue";
    divMostrarInfoUser.appendChild(h3);
    divMostrarInfoUser.style.display = "inline-block";

    
    divMostrarInfoUser.appendChild(tablas);
}


// MODIFICAR USER
 formModificarUser.addEventListener("submit",   (event) => {
    event.preventDefault();
    const nombre = event.target.querySelector("#nombreUserCAmbiar").value;
    const NuevoNombre = event.target.querySelector("#NuevoNombre").value;
     

    const raw = JSON.stringify({
      "nombre":NuevoNombre
    });
    const requestOptionsPUT = {
      method: "PUT",
      headers: myHeaders,
      body: raw,
      redirect: "follow"
    };
    let key=mapUser_ID.get(nombre);
    fetch("https://labingsoft.onrender.com/api/usuarios/"+ key, requestOptionsPUT)
  .then((response) => response.text())
  .then((result) => {
    console.log(result);
    alert("Usuario modificado con exito");
    formModificarUser.style.display = "none";
    infoUsuarios() ;
  })
  .catch((error) => console.error(error));
 });




//CREAR USER 
 formCrearUser.addEventListener("submit",   (event) => {
  event.preventDefault();
  const nombre = event.target.querySelector("#Nombre").value;
  const correo = event.target.querySelector("#correo").value;
  const password = event.target.querySelector("#password").value;
 
  //si password es menor de 8 dijitos no se crea el usuario

  if(password.length<8){
    alert("La contraseña debe tener al menos 8 caracteres");
    return;
  }else{
  const raw1 = JSON.stringify({
      "nombre": nombre,
      "correo": correo,
      "password": password
    });
    const requestOptionsPOST = {
      method: "POST",
      headers: myHeaders,
      body: raw1,
      redirect: "follow"
    };
    console.log(raw);
  fetch("https://labingsoft.onrender.com/api/usuarios", requestOptionsPOST)
  .then((response) => response.json())
  .then((data) => { // Aquí se utiliza directamente el objeto 'data'
    console.log(data);
    alert("Usuario creado con exito");
    formCrearUser.style.display = "none";
    infoUsuarios() ;
  })
  .catch((error) => console.error(error));
}
 }
 );

 //ELIMINAR USER
 formEliminarUser.addEventListener("submit",   (event) => {
  event.preventDefault();
  const nombre = event.target.querySelector("#nombreUserEliminar").value;
  let keydeleteuser=mapUser_ID.get(nombre);
  const raw = "";

const requestOptionsDelete = {
  method: "DELETE",
  headers: myHeaders,
  body: raw,
  redirect: "follow"
};
fetch("https://labingsoft.onrender.com/api/usuarios/"+keydeleteuser, requestOptionsDelete)
  .then((response) => response.text())
  .then((result) =>{
    console.log(result);
    
    alert("Usuario eliminado con exito");
    formEliminarUser.style.display = "none";
    infoUsuarios() ;

  })
  
  .catch((error) => console.error(error));
  
 });


  //-----------------------------------Funciones---- USUARIOS-------------------------------//
function MostrarOption(divaMostrar,mapCRUD) {
  divaMostrar.innerHTML = " ";
for (const key of mapCRUD.keys()) {
  let optionValue= document.createElement("option");
  optionValue.value= key;
  divaMostrar.appendChild(optionValue);
 

}
}


//-----------------------------------Funciones---- CATEGORIAS-------------------------------//
var cont2=1;
async function crearCategorias() {
  
if(cont2%2==0){
  formCrearCategorias.style.display = "none";
  cont2++;}
  else{
    
    formCrearCategorias.style.display = "block";
    cont2++;
  }
}
async function modificarCategorias() {
  if(cont2%2==0){
    formModificarCategorias.style.display = "none";
    cont2++;}
    else{
      
      
      formModificarCategorias.style.display = "block";
      cont2++;
    }
  }
  async function deleteCategorias() {
    if(cont2%2==0){
      formEliminarCategorias.style.display = "none";
      cont2++;}
      else{
        
        formEliminarCategorias.style.display = "block";
        cont2++;
      }
    }

     
async function infoCategorias() {
    let tablas = document.createElement('table');
    tablas.className = 'table-hover';
    const tr = document.createElement('tr');
    tr.className = 'table-primary';

    const thNombre = document.createElement('th');
    thNombre.textContent = 'Nombre';
    tr.appendChild(thNombre);

    const thCorreo = document.createElement('th');
    thCorreo.textContent = 'ID';
    tr.appendChild(thCorreo);

    

    tablas.appendChild(tr);

    const response = await  fetch("https://labingsoft.onrender.com/api/categorias",  requestOptionsGET);
    const data = await response.json();
    
    console.log(data);
    
    data.categorias.forEach((categoria) => {
      mapCategoria_ID.set(categoria.nombre,categoria._id);
        const tr = document.createElement('tr');
        tr.appendChild(document.createElement('td')).textContent = categoria.nombre;
        tr.appendChild(document.createElement('td')).textContent = categoria._id;
       
        tablas.appendChild(tr);
    });
    divMostrarInfoCategorias.innerHTML = " ";
    let h3 = document.createElement("h3");
    h3.textContent = "Categorias";
    h3.style.color="blue";
    divMostrarInfoCategorias.appendChild(h3);
    divMostrarInfoCategorias.style.display = "inline-block";
    divMostrarInfoCategorias.style.padding = "10px";
    divMostrarInfoCategorias.appendChild(tablas);
    MostrarOption(mostrarCategoria1,mapCategoria_ID);
    MostrarOption(mostrarCategoria1,mapCategoria_ID);
     
    DataListCrearVideoMostrarCategoria.innerHTML = " ";
    for (const key of mapCategoria_ID.keys()) {
      let optionValue= document.createElement("option");
      optionValue.value= key;
      optionValue.textContent= key;
      DataListCrearVideoMostrarCategoria.appendChild(optionValue);
    
    }
    console.log(DataListCrearVideoMostrarCategoria);
     
}
//CREAR CATEGORIA
formCrearCategorias.addEventListener("submit",   (event) => {
  event.preventDefault();
  const nombre = event.target.querySelector("#NombreNuevaCategoria").value;
  const raw = JSON.stringify({
    "nombre": nombre
  });
  const requestOptionsPOST = {
    method: "POST",
    headers: myHeaders,
    body: raw,
    redirect: "follow"
  };
  fetch("https://labingsoft.onrender.com/api/categorias", requestOptionsPOST)
  .then((response) => response.text())
  .then((result) => {
    console.log(result);
    
    alert("categoria creada con exito");
    formCrearCategorias.style.display = "none";
    infoCategorias() ;

  })
  .catch((error) => console.error(error));
});
//MODIFICAR CATEGORIA
formModificarCategorias.addEventListener("submit",   (event) => {
  event.preventDefault();
  const nombre = event.target.querySelector("#nombreCategoriaCambiar").value;
  const NuevoNombre = event.target.querySelector("#NuevoNombreCategoria").value;
  const raw = JSON.stringify({
    "nombre": NuevoNombre
  });
  const requestOptionsPUT = {
    method: "PUT",
    headers: myHeaders,
    body: raw,
    redirect: "follow"
  };
  let key=mapCategoria_ID.get(nombre);
  console.log(key);
  console.log(raw);
  fetch("https://labingsoft.onrender.com/api/categorias/"+ key, requestOptionsPUT)
  .then((response) => response.text())
  .then((result) => {
    console.log(result);
    alert("Categoria modificada con exito");
    formModificarCategorias.style.display = "none";
    infoCategorias() ;
  })
  .catch((error) => console.error(error));
});

//ELIMINAR CATEGORIA
formEliminarCategorias.addEventListener("submit",   (event) => {
  event.preventDefault();
  const nombre = event.target.querySelector("#nombreCategoriaEliminar").value;
  let keydelete=mapCategoria_ID.get(nombre);
  
  const requestOptionsDELETE = { 
    method: "DELETE",
    headers: myHeaders,
    redirect: "follow"
  };
  fetch("https://labingsoft.onrender.com/api/categorias/"+keydelete, requestOptionsDELETE)
  .then((response) => response.text())
  .then((result) => {
    console.log(result);
    alert("Categoria eliminada con exito");
    formEliminarCategorias.style.display = "none";
    infoCategorias() ;
  })
  .catch((error) => console.error(error));
});


//-----------------------------------Funciones---- CATEGORIAS-------------------------------//



//-----------------------------------Funciones---- VIDEOS-------------------------------//

var cont3=1;
async function crearVideos() {
    
    if(cont3%2==0){
      formCrearVideos.style.display = "none";
      cont3++;}
      else{
        
        formCrearVideos.style.display = "block";
        cont3++;
      }
    }


   async function ModificarVideos() {
    if(cont3%2==0){
      formModificarVideos.style.display = "none";
      cont3++;}
      else{
        
        formModificarVideos.style.display = "block";
        cont3++;
      }
    }
    
   async function DeletVideos() {
    if(cont3%2==0){
      formEliminarVideos.style.display = "none";
      cont3++;}
      else{
        
        formEliminarVideos.style.display = "block";
        cont3++;
      }
    } 
    //crear video

    formCrearVideos.addEventListener("submit",   (event) => {
      event.preventDefault();
      let nombre = event.target.querySelector("#NombreNuevoVideo").value;
      let url = event.target.querySelector("#URLNuevoVideo").value;
      let categoria = event.target.querySelector("#CategoriaNuevoVideo").value;
      let keyCategoria=mapCategoria_ID.get(categoria);
       ;
      let rawCrearVideo = JSON.stringify({
        "nombre": nombre ,
        "url":  url,
        "categoria":keyCategoria
      });
      let requestOptionsPOST = {
        method: "POST",
        headers: myHeaders,
        body: rawCrearVideo,
        redirect: "follow"
      };
      fetch("https://labingsoft.onrender.com/api/videos", requestOptionsPOST)
  .then((response) => response.text())
  .then((result) =>
  {
    console.log(result);
    alert("Video creado con exito");
    formCrearVideos.style.display = "none";
    InfoVideos() ;
  })  
  .catch((error) => console.error(error));
    });

    //MODIFICAR VIDEO
    formModificarVideos.addEventListener("submit",   (event) => {
      event.preventDefault();
      const nombre = event.target.querySelector("#nombreVideoCambiar").value;
      const NuevoNombre = event.target.querySelector("#NuevoNombreVideo").value;
      const nuevaURL = event.target.querySelector("#NuevaURLVideo").value;
      const raw = JSON.stringify({
        "nombre": NuevoNombre,
        "url": nuevaURL

      });
      const requestOptionsPUT = {
        method: "PUT",
        headers: myHeaders,
        body: raw,
        redirect: "follow"
      };
      let key=mapVideo_ID.get(nombre);
      fetch("https://labingsoft.onrender.com/api/videos/"+ key, requestOptionsPUT)
      .then((response) => response.text())
      .then((result) => {
        console.log(result);
        alert("Video modificado con exito");
        formModificarVideos.style.display = "none";
        InfoVideos() ;
      })
      .catch((error) => console.error(error));
    });
    //ELIMINAR VIDEO
    formEliminarVideos.addEventListener("submit",   (event) => {
      event.preventDefault();
      const nombre = event.target.querySelector("#nombreVideoEliminar").value;
      let keydelete=mapVideo_ID.get(nombre);
      const requestOptionsDELETE = {
        method: "DELETE",
        headers: myHeaders,
        redirect: "follow"
      };
      fetch("https://labingsoft.onrender.com/api/videos/"+keydelete, requestOptionsDELETE)
      .then((response) => response.text())
      .then((result) => {
        console.log(result);
        alert("Video eliminado con exito");
        formEliminarVideos.style.display = "none";
        InfoVideos() ;
      })
      .catch((error) => console.error(error));
    });
async function InfoVideos() {
    let tablas = document.createElement('table');
    tablas.className = 'table-hover';
    const tr = document.createElement('tr');
    tr.className = 'table-primary';

    const thNombre = document.createElement('th');
    thNombre.textContent = 'Nombre';
    tr.appendChild(thNombre);

    const thCategoira = document.createElement('th');
    thCategoira.textContent = 'categoria';
    tr.appendChild(thCategoira);

   
    

    tablas.appendChild(tr);

    const response = await  fetch("https://labingsoft.onrender.com/api/videos?limite=100&desde=0",  requestOptionsGET);
    const data = await response.json();
    
    console.log(data);
    
    data.productos.forEach((videos) => {
      mapVideo_ID.set(videos.nombre,videos._id);
        const tr = document.createElement('tr');
        tr.appendChild(document.createElement('td')).textContent = videos.nombre;
        tr.appendChild(document.createElement('td')).textContent = videos.categoria.nombre;
       
        const a = document.createElement("a");
        a.href = videos.url;
        a.className = "btn btn-primary";
        a.textContent = "Ver en YouTube";
        tr.appendChild(a);
        tablas.appendChild(tr);
    });
    divMostrarInfoVideos.innerHTML = " ";
    let h3 = document.createElement("h3");
    h3.textContent = "Videos";
    h3.style.color="blue";
    divMostrarInfoVideos.appendChild(h3);
    divMostrarInfoVideos.style.display = "inline-block";
    divMostrarInfoVideos.style.padding = "10px";
    
    divMostrarInfoVideos.appendChild(tablas);
    MostrarOption(mostrarVideoModificar,mapVideo_ID);
    MostrarOption(DataListCrearVideoMostrarCategoria,mapVideo_ID);
}




//-----------------------------------Funciones---- VIDEOS-------------------------------//

   