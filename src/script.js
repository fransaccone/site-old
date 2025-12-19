const titleSelector = "h1#pronunciation-francesco-saccone";
const title = document.querySelector(titleSelector);

if (title) {
	const speaker = document.createElement("img");
	const style = document.createElement("style");
	const audio = new Audio("/public/francescosaccone.wav");

	title.firstChild.remove();

	speaker.src = "/public/speaker.svg";
	speaker.alt = "<Audio>";

	title.insertAdjacentText("afterbegin", " ");
	title.insertAdjacentElement("afterbegin", speaker);

	style.textContent = `
		${titleSelector}:hover {
			cursor: pointer;
		}

		${titleSelector} > img {
			filter: var(--fgdimfilter);
			transition: filter var(--transitiontime);
		}

		${titleSelector}.audio-playing > img {
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
