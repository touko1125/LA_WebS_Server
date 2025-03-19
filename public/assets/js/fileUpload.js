const fileSelect = document.getElementById("select-file");
const fileElem = document.getElementById("image-file");

fileSelect.addEventListener("click", (e) => {
  if (fileElem) {
    fileElem.click();
  }
}, false);