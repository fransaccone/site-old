let title = null;

for (const e of document.querySelectorAll("h1")) {
	if (e.textContent.trim() == "Francesco Saccone")
		title = e;
}

if (title) {
	const id = "francesco-saccone";
	const selector = `h1#${id}`;
	const speaker = document.createElement("img");
	const style = document.createElement("style");
	const audio = new Audio("/public/francescosaccone.wav");

	title.id = id;

	title.firstChild.remove();

	speaker.src = "/public/speaker.svg";
	speaker.alt = "<Audio>";

	title.insertAdjacentText("afterbegin", " ");
	title.insertAdjacentElement("afterbegin", speaker);

	style.textContent = `
		${selector}:hover {
			cursor: pointer;
		}

		${selector} > img {
			filter: var(--fgdimfilter);
			transition: filter var(--transitiontime);
		}

		${selector}.audio-playing > img {
			filter: var(--fgfilter);
		}
	`;
	document.head.appendChild(style);

	title.addEventListener("click", () => {
		title.classList.add("audio-playing");
		audio.play();
	});

	audio.addEventListener("ended", () => {
		title.classList.remove("audio-playing");
	});
}
