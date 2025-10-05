let cart = [];

// Initialize
document.addEventListener("DOMContentLoaded", () => {
  setupEventListeners();
  updateCart();
});

function setupEventListeners() {
  // Add to cart buttons
  const addButtons = document.querySelectorAll(".add-to-cart");
  addButtons.forEach((btn) => {
    btn.addEventListener("click", addToCart);
  });

  // Checkout button
  const checkoutBtn = document.getElementById("checkout-btn");
  checkoutBtn.addEventListener("click", checkout);
}

function addToCart(e) {
  const btn = e.target;
  const productId = btn.getAttribute("data-id");
  const productName = btn.getAttribute("data-name");
  const productPrice = parseFloat(btn.getAttribute("data-price"));

  // Check if product already in cart
  const existingItem = cart.find((item) => item.id === productId);

  if (existingItem) {
    existingItem.quantity++;
  } else {
    cart.push({
      id: productId,
      name: productName,
      price: productPrice,
      quantity: 1,
    });
  }

  updateCart();

  // Visual feedback
  btn.textContent = "Added!";
  btn.style.backgroundColor = "#27ae60";
  setTimeout(() => {
    btn.textContent = "Add to Cart";
    btn.style.backgroundColor = "#3498db";
  }, 1000);
}

function removeFromCart(productId) {
  cart = cart.filter((item) => item.id !== productId);
  updateCart();
}

function updateCart() {
  const cartItemsDiv = document.getElementById("cart-items");
  const cartCount = document.getElementById("cart-count");
  const totalPrice = document.getElementById("total-price");
  const checkoutBtn = document.getElementById("checkout-btn");

  // Update cart count
  const totalItems = cart.reduce((sum, item) => sum + item.quantity, 0);
  cartCount.textContent = totalItems;

  // Update total price
  const total = cart.reduce((sum, item) => sum + item.price * item.quantity, 0);
  totalPrice.textContent = total.toFixed(2);

  // Update cart items display
  if (cart.length === 0) {
    cartItemsDiv.innerHTML = '<p class="empty-cart">Your cart is empty</p>';
    checkoutBtn.disabled = true;
  } else {
    cartItemsDiv.innerHTML = cart
      .map(
        (item) => `
            <div class="cart-item">
                <div>
                    <strong>${item.name}</strong> x ${item.quantity}
                    <br>
                    <span style="color: #27ae60;">$${(
                      item.price * item.quantity
                    ).toFixed(2)}</span>
                </div>
                <button onclick="removeFromCart('${item.id}')">Remove</button>
            </div>
        `
      )
      .join("");
    checkoutBtn.disabled = false;
  }
}

function checkout() {
  if (cart.length === 0) {
    alert("Your cart is empty!");
    return;
  }

  const total = cart.reduce((sum, item) => sum + item.price * item.quantity, 0);
  alert(
    `Thank you for your order!\n\nTotal: $${total.toFixed(
      2
    )}\n\nThis is a demo. No actual payment was processed.`
  );

  // Clear cart
  cart = [];
  updateCart();
}
