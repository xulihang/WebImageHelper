function replaceImgSrc(src1,replacedSrc,src2){
	var imgs = document.getElementsByTagName("img");
	for (i = 0; i <= imgs.length-1; i++){
		if (imgs[i].src==src1 || imgs[i].src==replacedSrc){
			imgs[i].src=src2;
			return "success"
		}
	}
	return "fail"
}


function getAllImageSrc(){
	var imgs = document.getElementsByTagName("img");
	var srcArray=[];
	for (i = 0; i <= imgs.length-1; i++){
		srcArray.push(imgs[i].src)
	}
	return srcArray;
}

function getImageSrc(x,y){
	var e=getImage(x,y);
	if (e==null){
		return "";
	}else
	{
		return e.src;
	}
}

function getImage(x,y){
	var e = document.elementFromPoint(x,y);
	if (e==null){
		return null;
	}
	if (isImg(e)==true){
		return e;
	}
	else{
		return getImageInside(e,y);
	}
}

function getImageInside(e,y){
	var imgs = e.getElementsByTagName("img");
	for (i = 0; i <= imgs.length-1; i++){
		console.log(i)
		var innerElement = imgs[i];
		if (inDisplay(innerElement)==true){
			if (isImg(innerElement)==true){
				return innerElement;
			}else{
				if (innerElement.getElementsByTagName("img").length>0){
					var element = getImageInside(innerElement,y);
					if (isImg(element)==true){
						return element;	
					}
				}
			}
		}
	}
	return imgs[imgs.length-1];
}


function getImageInside2(e,y){
	for (i = 0; i <= e.children.length-1; i++){
		console.log(i)
		var innerElement = e.children[i];
		if (inDisplay(innerElement)==true){
			if (isImg(innerElement)==true){
				return innerElement;
			}else{
				if (innerElement.children.length>0){
					var element = getImageInside(innerElement,y);
					if (isImg(element)==true){
						return element;	
					}
				}
			}
		}
	}
	return document.getElementsByTagName("img")[0];
}

function isImg(e){
	if (e.tagName.toLowerCase()=="img"){
		return true;
	}
	else
	{
		return false;
	}
}

function inDisplay(img){
	var top = img.offsetTop;
	var bottom = img.offsetTop+img.offsetHeight;
	var upBound = document.documentElement.scrollTop;
	if ( upBound>top && upBound<bottom){
		return true;
	}
	else
	{
		return false;
	}
}
