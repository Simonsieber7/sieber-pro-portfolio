document.addEventListener('DOMContentLoaded', () => {
    console.log('Sieber Pro Portfolio loaded');

    // Smooth scrolling for anchor links
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                target.scrollIntoView({
                    behavior: 'smooth'
                });
            }
        });
    });

    // Theme Toggle Logic (Placeholder for now, defaults to dark)
    const themeToggle = document.querySelector('.theme-toggle');
    // Logic to toggle classes or local storage can be added here
});
