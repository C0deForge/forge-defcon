let defconActive = false;

// Listen for messages from other windows or iframes
window.addEventListener('message', function(event) {

    if (event.data.action === 'showDefconUI') {
        // Apply a smooth transition animation when changing DEFCON levels
        const defconUI = document.getElementById('defconUI');
        defconUI.style.transition = 'all 0.5s ease';  // Smooth animation
        defconUI.style.opacity = '0'; // Briefly hide for animation effect

        setTimeout(() => {
            // Update the DEFCON number (only the number, without redundant text)
            document.getElementById('defconNumber').innerText = event.data.defconLevel;
            document.getElementById('defconNumber').style.backgroundColor = event.data.defconColor;

            // Show the UI with an entrance animation
            defconUI.style.display = 'flex';
            setTimeout(function() {
                defconUI.style.left = '20px'; // Slide in from the left
                defconUI.style.opacity = '1';  // Show with animation
            }, 100);
        }, 300); // Short delay to visualize the change between DEFCONs

        // Activate radar tracking only if DEFCON is active
        defconActive = true;

    } else if (event.data.action === 'clearDefconUI') {
        // Hide the UI with an exit animation
        document.getElementById('defconUI').style.left = '-300px'; // Slide out to the left
        document.getElementById('defconUI').style.opacity = '0';
        setTimeout(function() {
            document.getElementById('defconUI').style.display = 'none';
        }, 500);

        // Deactivate radar tracking when DEFCON is inactive
        defconActive = false;

    } else if (event.data.action === 'moveUp') {
        // Move the UI further up when the radar is visible
        document.getElementById('defconUI').style.bottom = '225px'; // Raise the UI
    } else if (event.data.action === 'moveDown') {
        // Move the UI down when the radar disappears
        document.getElementById('defconUI').style.bottom = '20px'; // Return to original position
    }
});