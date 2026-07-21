const controlsBar = document.getElementById('controls-bar');
const pointIndicators = document.getElementById('point-indicators');
const durationModal = document.getElementById('duration-modal');
const durationInput = document.getElementById('duration-input');
const btnConfirm = document.getElementById('btn-confirm');
const btnCancel = document.getElementById('btn-cancel');
const chkAddMore = document.getElementById('chk-add-more');
const modalTitle = document.getElementById('modal-title');
const modalSubtitle = document.getElementById('modal-subtitle');
const statusA = document.getElementById('status-a');
const statusB = document.getElementById('status-b');
const labelA = document.getElementById('label-a');
const labelB = document.getElementById('label-b');
const badgeTransition = document.getElementById('badge-transition');
const transitionFill = document.getElementById('transition-fill');
const transitionLabel = document.getElementById('transition-label');
const uiToast = document.getElementById('ui-toast');
const uiToastText = document.getElementById('ui-toast-text');
const uiToastIcon = document.getElementById('ui-toast-icon');

let transitionInterval = null;
let toastTimeout = null;
let currentSegmentNumber = 1;

function showToast(message, icon = '🔔', type = 'info', duration = 2500) {
    clearTimeout(toastTimeout);
    uiToast.className = `ui-toast type-${type}`;
    uiToastIcon.textContent = icon;
    uiToastText.textContent = message;
    void uiToast.offsetWidth;
    uiToast.classList.add('visible');
    toastTimeout = setTimeout(() => {
        uiToast.classList.remove('visible');
        uiToast.classList.add('hidden');
        setTimeout(() => uiToast.classList.remove('hidden'), 300);
    }, duration);
}

function showControls() {
    controlsBar.classList.remove('hidden');
    pointIndicators.classList.remove('hidden');
}

function hideControls() {
    controlsBar.classList.add('hidden');
    pointIndicators.classList.add('hidden');
}

function resetUI() {
    currentSegmentNumber = 1;
    statusA.textContent = '—';
    statusA.classList.remove('active');
    statusB.textContent = '—';
    statusB.classList.remove('active');
    labelA.textContent = 'Point A';
    labelB.textContent = 'Point B';
    badgeTransition.style.display = 'none';
    clearInterval(transitionInterval);
}

function openDurationModal() {
    durationModal.classList.remove('hidden');
    setTimeout(() => durationInput.focus(), 50);
}

function closeDurationModal(confirm) {
    durationModal.classList.add('hidden');
    const addMore = chkAddMore.checked;
    if (confirm) {
        const ms = Math.round(parseFloat(durationInput.value) * 1000) || 5000;
        fetch(`https://zx_photomode/setDuration`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ duration: ms, addMore: addMore })
        });
        if (!addMore) {
            // Reset modal state for next time
            chkAddMore.checked = false;
        }
    } else {
        chkAddMore.checked = false;
    }
    fetch(`https://zx_photomode/closeDurationModal`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ confirmed: confirm })
    });
}

function startTransitionProgress(durationMs) {
    badgeTransition.style.display = 'flex';
    transitionFill.style.width = '0%';
    const start = Date.now();
    clearInterval(transitionInterval);
    transitionInterval = setInterval(() => {
        const elapsed = Date.now() - start;
        const pct = Math.min((elapsed / durationMs) * 100, 100);
        transitionFill.style.width = pct + '%';
        const remaining = Math.max(0, (durationMs - elapsed) / 1000);
        transitionLabel.textContent = `Transition — ${remaining.toFixed(1)}s`;
        if (pct >= 100) {
            clearInterval(transitionInterval);
            setTimeout(() => { badgeTransition.style.display = 'none'; }, 600);
        }
    }, 50);
}


const dofPanel = document.getElementById('dof-panel');
const btnDofToggle = document.getElementById('btn-dof-toggle');
const dofClose = document.getElementById('dof-close');
const dofEnabled = document.getElementById('dof-enabled');
const sliderStrength = document.getElementById('slider-strength');
const sliderNear = document.getElementById('slider-near');
const sliderFar = document.getElementById('slider-far');
const valStrength = document.getElementById('val-strength');
const valNear = document.getElementById('val-near');
const valFar = document.getElementById('val-far');
const filterSelect = document.getElementById('filter-select');
const sliderFilterStrength = document.getElementById('slider-filter-strength');
const valFilterStrength = document.getElementById('val-filter-strength');
const filterEnabled = document.getElementById('filter-enabled');

const shakeEnabled = document.getElementById('shake-enabled');
const sliderShakeStrength = document.getElementById('slider-shake-strength');
const valShakeStrength = document.getElementById('val-shake-strength');

let dofPanelOpen = false;

function sendEffectsUpdate() {
    const enabled = dofEnabled.checked;
    const strength = parseFloat(sliderStrength.value);
    const near = parseFloat(sliderNear.value);
    const far = parseFloat(sliderFar.value);
    
    const filtEnabled = filterEnabled.checked;
    const filter = filterSelect.value;
    const filterStrength = parseFloat(sliderFilterStrength.value);
    
    const shakEnabled = shakeEnabled.checked;
    const shakeStrength = parseFloat(sliderShakeStrength.value);

    valStrength.textContent = strength.toFixed(2);
    valNear.textContent = near.toFixed(1);
    valFar.textContent = far.toFixed(1);
    valFilterStrength.textContent = filterStrength.toFixed(2);
    valShakeStrength.textContent = shakeStrength.toFixed(2);

    btnDofToggle.classList.toggle('active', enabled);

    fetch(`https://zx_photomode/updateEffects`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ enabled, strength, near, far, filterEnabled: filtEnabled, filter, filterStrength, shakeEnabled: shakEnabled, shakeStrength })
    });
}

function openEffectsPanel() {
    dofPanelOpen = true;
    dofPanel.classList.remove('hidden');
    fetch(`https://zx_photomode/openEffectsPanel`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({})
    });
}

function closeEffectsPanel() {
    dofPanelOpen = false;
    dofPanel.classList.add('hidden');
    fetch(`https://zx_photomode/closeEffectsPanel`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({})
    });
}

btnDofToggle.addEventListener('click', () => {
    if (dofPanelOpen) {
        closeEffectsPanel();
    } else {
        openEffectsPanel();
    }
});

dofClose.addEventListener('click', closeEffectsPanel);

dofEnabled.addEventListener('change', sendEffectsUpdate);
sliderStrength.addEventListener('input', sendEffectsUpdate);
sliderNear.addEventListener('input', sendEffectsUpdate);
sliderFar.addEventListener('input', sendEffectsUpdate);
filterEnabled.addEventListener('change', sendEffectsUpdate);
filterSelect.addEventListener('change', sendEffectsUpdate);
sliderFilterStrength.addEventListener('input', sendEffectsUpdate);
shakeEnabled.addEventListener('change', sendEffectsUpdate);
sliderShakeStrength.addEventListener('input', sendEffectsUpdate);


window.addEventListener('message', (e) => {
    const data = e.data;
    switch (data.action) {
        case 'setFilters':
            if (data.filters) {
                filterSelect.innerHTML = '';
                data.filters.forEach(f => {
                    const option = document.createElement('option');
                    option.value = f.value;
                    option.textContent = f.label;
                    filterSelect.appendChild(option);
                });
            }
            break;
        case 'setKeys':
            const keys = data.keys;
            if (keys) {
                if (keys.Forward) document.getElementById('key-forward').textContent = keys.Forward;
                if (keys.Backward) document.getElementById('key-backward').textContent = keys.Backward;
                if (keys.Left) document.getElementById('key-left').textContent = keys.Left;
                if (keys.Right) document.getElementById('key-right').textContent = keys.Right;
                if (keys.Up) document.getElementById('key-up').textContent = keys.Up;
                if (keys.Down) document.getElementById('key-down').textContent = keys.Down;
                if (keys.Roll) document.getElementById('key-roll').textContent = keys.Roll;
                if (keys.Speed) document.getElementById('key-speed').textContent = keys.Speed;
                if (keys.SetPoint) document.getElementById('key-setpoint').textContent = keys.SetPoint;
                if (keys.ToggleUI) document.getElementById('key-toggleui').textContent = keys.ToggleUI;
                if (keys.Quit) document.getElementById('key-quit').textContent = keys.Quit;
                if (keys.Dof) document.getElementById('key-dof').textContent = keys.Dof;
                if (keys.ClearPoints) document.getElementById('key-clearpoints').textContent = keys.ClearPoints;
            }
            break;
        case 'showUI':
            showControls();
            break;
        case 'hideUI':
            hideControls();
            resetUI();
            closeEffectsPanel();
            break;
        case 'showControls':
            showControls();
            break;
        case 'hideControls':
            hideControls();
            break;
        case 'openDuration':
            openDurationModal();
            break;
        case 'pointSet':
            if (data.point === 'A') {
                statusA.textContent = '✓';
                statusA.classList.add('active');
                labelA.textContent = `Début (Seg. ${currentSegmentNumber})`;
            } else {
                statusB.textContent = '✓';
                statusB.classList.add('active');
                labelB.textContent = `Fin (Seg. ${currentSegmentNumber})`;
            }
            break;
        case 'resetPoints':
            resetUI();
            showToast('Transitions effacées', '🗑️', 'reset', 2000);
            break;
        case 'segmentAdded':
            // Segment confirmed, prepare for the next one
            currentSegmentNumber = data.segmentCount + 1;
            statusA.textContent = '✓';
            statusA.classList.add('active');
            labelA.textContent = `Début (Seg. ${currentSegmentNumber})`;
            statusB.textContent = '—';
            statusB.classList.remove('active');
            labelB.textContent = `Fin (Seg. ${currentSegmentNumber})`;
            modalTitle.textContent = `Transition ${currentSegmentNumber}`;
            modalSubtitle.textContent = `Durée du segment ${currentSegmentNumber}`;
            showToast(`Segment ${currentSegmentNumber - 1} enregistré ✓`, '📍', 'success', 2000);
            break;
        case 'transitionStart':
            startTransitionProgress(data.duration);
            break;
        case 'openEffectsPanel':
            dofPanel.classList.remove('hidden');
            dofPanelOpen = true;
            if (data.effects) {
                dofEnabled.checked = data.effects.enabled;
                sliderStrength.value = data.effects.strength;
                sliderNear.value = data.effects.near;
                sliderFar.value = data.effects.far;
                
                filterEnabled.checked = data.effects.filterEnabled;
                filterSelect.value = data.effects.filter || 'none';
                sliderFilterStrength.value = data.effects.filterStrength || 1.0;
                
                shakeEnabled.checked = data.effects.shakeEnabled;
                sliderShakeStrength.value = data.effects.shakeStrength || 0.5;
                
                valStrength.textContent = parseFloat(data.effects.strength).toFixed(2);
                valNear.textContent = parseFloat(data.effects.near).toFixed(1);
                valFar.textContent = parseFloat(data.effects.far).toFixed(1);
                valFilterStrength.textContent = parseFloat(sliderFilterStrength.value).toFixed(2);
                valShakeStrength.textContent = parseFloat(sliderShakeStrength.value).toFixed(2);
                
                btnDofToggle.classList.toggle('active', data.effects.enabled);
            }
            break;
        case 'closeEffectsPanel':
            dofPanel.classList.add('hidden');
            dofPanelOpen = false;
            break;
    }
});

btnConfirm.addEventListener('click', () => closeDurationModal(true));
btnCancel.addEventListener('click', () => closeDurationModal(false));

durationInput.addEventListener('keydown', (e) => {
    if (e.key === 'Enter') closeDurationModal(true);
    if (e.key === 'Escape') closeDurationModal(false);
});
