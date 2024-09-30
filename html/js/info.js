let previousCash = null; 
let previousBank = null; 

window.addEventListener('message', function (event) {
    if (event.data.action === 'updateHUD') {
        const hudElement = document.getElementById('hud');

        if (event.data.playerLoaded) {
            hudElement.classList.add('show'); 
        }

        document.querySelector('#server-id span').textContent = event.data.serverId; 

        document.querySelector('#job-info').textContent =
            event.data.jobLabel + ' | ' + event.data.jobGrade; 

        document.querySelector('#gang-info').textContent =
            event.data.gangLabel + (event.data.gangGrade ? ' | ' + event.data.gangGrade : ''); 

        const currentCash = event.data.cash;
        document.querySelector('#cash-label span').textContent = '$' + currentCash.toLocaleString(); 

        if (previousCash !== null && previousCash !== currentCash) {
            const cashDifference = currentCash - previousCash;
            showNotification(
                `Cash ${(cashDifference > 0 ? `+` : `-`)}$${Math.abs(cashDifference).toLocaleString()}`, 
                document.querySelector('#cash-label'), // Wallet icon for cash change
                'Cash' // Add type as "Cash"
            );
        }
        previousCash = currentCash; 

        const currentBank = event.data.bank;
        document.querySelector('#bank-label span').textContent = '$' + currentBank.toLocaleString(); 

        if (previousBank !== null && previousBank !== currentBank) {
            const bankDifference = currentBank - previousBank;
            showNotification(
                `Bank ${(bankDifference > 0 ? `+` : `-`)}$${Math.abs(bankDifference).toLocaleString()}`, 
                document.querySelector('#bank-label'), // Correct reference to bank label
                'Bank' // Add type as "Bank"
            );
        }
        previousBank = currentBank; 

        const ammoBar = document.querySelector('#ammo-label');
        if (event.data.hasWeapon) {
            ammoBar.classList.remove('hidden');
            ammoBar.classList.add('show'); 
            ammoBar.querySelector('span').textContent = ` ${event.data.currentMagazine} |  ${event.data.ammo}`; 
        } else {
            ammoBar.classList.remove('show');
            ammoBar.classList.add('hidden');
        }
    }
});

window.addEventListener('message', function (event) {
    if (event.data.action === 'toggleHUD') {
        const hudElement = document.getElementById('hud');
        if (event.data.visible) {
            hudElement.classList.remove('hidden');
        } else {
            hudElement.classList.add('hidden');
        }
    }
});

window.addEventListener('message', function (event) {
    if (event.data.action === 'playerLoaded') {
        const hudElement = document.getElementById('hud');
        hudElement.classList.add('show'); 
    }
});

function showNotification(message, referenceElement) {
    const existingNotification = document.querySelector('.notification');
    if (existingNotification) {
        existingNotification.remove();
    }

    const notification = document.createElement('div');
    notification.className = 'notification';
    notification.textContent = message; 

    if (message.includes('+')) {
        notification.style.color = '#28a745'; 
        notification.style.fontWeight = 'bold'; 
    } else if (message.includes('-')) {
        notification.style.color = '#dc3545'; 
        notification.style.fontWeight = 'bold'; 
    }

    const hudElement = document.getElementById('hud');
    const hudRect = hudElement.getBoundingClientRect();
    notification.style.position = 'absolute';
    notification.style.top = `${hudRect.top + hudRect.height / 2}px`; 
    notification.style.left = `${hudRect.left + hudRect.width / 2}px`; 
    notification.style.opacity = '0'; 
    notification.style.transform = 'translateX(0)'; 
    notification.style.transition = 'opacity 0.5s ease, transform 0.5s ease'; 
    notification.style.zIndex = '1000'; 

    document.body.appendChild(notification);

    setTimeout(() => {
        notification.style.opacity = '1';
        notification.style.transform = 'translateX(-220px)'; 
    }, 10); 

    setTimeout(() => {
        notification.remove();
    }, 6000);
}
