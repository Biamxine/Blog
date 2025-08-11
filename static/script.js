const top_nav = document.getElementById('top_nav');
const top_nav_a_list = top_nav.querySelectorAll('a');
const isIndexPage = window.location.pathname === '/';
const back_top = document.getElementById('back_top');

if (!isIndexPage) {
    top_nav.classList.add('scrolled');
    for (let i = 0; i < top_nav_a_list.length; i++) {
        top_nav_a_list[i].classList.add('scrolled');
    }
}
else {
    window.addEventListener('scroll', () => {
        if (window.scrollY > 0) {
            back_top.classList.add('scrolled');
            top_nav.classList.add('scrolled');
            for (let i = 0; i < top_nav_a_list.length; i++) {
                top_nav_a_list[i].classList.add('scrolled');
            }
        } else {
            back_top.classList.remove('scrolled');
            top_nav.classList.remove('scrolled');
            for (let i = 0; i < top_nav_a_list.length; i++) {
                top_nav_a_list[i].classList.remove('scrolled');
            }
        }
    });
}

back_top.addEventListener('click', () => {
    window.scrollTo({
        top: 0,
        behavior: 'smooth'
    });
});


let distance_top_to_posts = document.getElementById('index_posts_box').getBoundingClientRect().top - document.getElementById('top_nav').getBoundingClientRect().height
const index_scroll_to_posts = document.getElementById('index_scroll_to_posts');
index_scroll_to_posts.addEventListener('click', () => {
    window.scrollTo({
        top: distance_top_to_posts,
        behavior: 'smooth'
    });
});

let last_stat = null;
function updateSearchVisibility() {
    let top_nav_bottom = document.getElementById('top_nav').getBoundingClientRect().bottom;
    let index_search_rect_top = document.getElementById('index_search').getBoundingClientRect().top;
    if (!top_nav_bottom || !index_search_rect_top) {
        console.error('Required elements not found');
        return;
    }
    let current_stat = top_nav_bottom > index_search_rect_top;
    if (current_stat == last_stat) {
        return;
    }
    last_stat = current_stat;
    if (top_nav_bottom > index_search_rect_top) {
        document.getElementById('index_search').style.visibility = 'hidden';
        document.getElementById('top_nav_search').value = document.getElementById('index_search').value;
        document.getElementById('top_nav_search').style.visibility = 'visible';
    }
    else {
        document.getElementById('top_nav_search').style.visibility = 'hidden';
        document.getElementById('index_search').value = document.getElementById('top_nav_search').value;
        document.getElementById('index_search').style.visibility = 'visible';
    }
}

updateSearchVisibility()
window.addEventListener('scroll', () => {
    window.requestAnimationFrame( updateSearchVisibility );
});