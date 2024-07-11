
 
const form = document.querySelector('form');
const alerta = document.getElementById("alerta");
const cargando= document.getElementById("cargando");
const mostrarCategoria = document.getElementById("DataList");
 
const map1 = new Map();
// Definir constantes para URLs y selectores
const API_URL = "https://labingsoft.onrender.com/api/videos/padre";
const VIDEOS_CONTAINER = document.getElementById("videos");

// Mover la función mostrarVideo fuera del área de código principal
function mostrarVideo(video) {
    const div = document.createElement("div");
    div.classList.add("card", "d-inline-flex", "flex-column", "align-items-center", "m-2");
    div.style.width = "18.87rem";
    div.style.flexDirection = "row";
    div.style.flexWrap = "wrap";
     
     
    const iframe = document.createElement("iframe");
    iframe.src = video.url;
    iframe.title = video.nombre;
    iframe.classList.add("embed-responsive-item");

    const ul = document.createElement("ul");
    ul.className = "list-group list-group-flush";

    const li = document.createElement("li");
    li.className = "list-group-item";
    li.textContent = video.categoria.nombre;
    ul.appendChild(li);

    const h4 = document.createElement("h4");
    h4.className = "card-title";
    h4.textContent = video.nombre;

    const a = document.createElement("a");
    a.href = video.url;
    a.className = "btn btn-primary";
    a.textContent = "Ver en YouTube";

    div.appendChild(iframe);
    div.appendChild(ul);
    div.appendChild(h4);
    div.appendChild(a);
    
     
    map1.set(video.categoria.nombre,video.categoria._id);
  
     
    return div;
}
    function mostrarCategorias() {
    mostrarCategoria.innerHTML = " ";
     
    for (const key of map1.keys()) {
        let optionValue= document.createElement("option");
        optionValue.value= key;
        mostrarCategoria.appendChild(optionValue);
         
       
    }
    
     }

form.addEventListener("submit", async (event) => {
    event.preventDefault();

    const numeroVideos = event.target.querySelector("#numeroVideos").value;
    const categoria = event.target.querySelector("#categoria").value;
    const token = localStorage.getItem("Token");

    if (!token) {
        alert("No has iniciado sesión. Por favor, inicia sesión para ver los videos");
        window.location.href = "index.html";
         
    }

    const requestOptions = {
        method: "GET",
        headers: new Headers({
            "Authorization": `Bearer ${token}`
        }),
        redirect: "follow"
    };

    try {
        cargando.className = "spinner-border text-primary spinner-border-sm";

        let response;
        if (categoria === "") {
            response = await fetch(`${API_URL}/?limite=${numeroVideos}&desde=0`, requestOptions);
            console.log(numeroVideos);
             
        } else {
            
              const IDCat =map1.get(categoria);
            response = await fetch(`${API_URL}/categoria/${IDCat}`, requestOptions);
        }

        if (!response.ok) {
            alert("Error al obtener los videos");
        }

        const data = await response.json();
        VIDEOS_CONTAINER.innerHTML = "";
        data.productos.forEach((video) => {
            const videoElement = mostrarVideo(video);
          
            VIDEOS_CONTAINER.appendChild(videoElement);
            mostrarCategorias();
        });
    } catch (error) {
        console.error("Error:", error);
        alerta.className = "alert alert-danger";
        alerta.textContent = "Error al obtener los videos debido a " + error;
    } finally {
        cargando.className = "";
    }
});
