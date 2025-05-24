<%@page import="java.math.BigDecimal"%>
<%@page import="model.Review"%>
<%@page import="java.util.List"%>
<%@page import="model.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.Tour" %>

<%
    Tour tour = (Tour) request.getAttribute("tour");
    User user = (User) request.getSession().getAttribute("user");
    String error = (String) request.getAttribute("error");
    List<Review> reviews = (List<Review>) request.getAttribute("reviews");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Chi Tiết Tour</title>
        <!-- Thêm Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Thêm Bootstrap JS (nếu cần) -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
        <!-- CSS hiện tại của bạn ở đây -->
        <style>
            /* Đảm bảo nội dung sát với header */
            .tour-container {
                padding-top: 20px;
                padding-bottom: 40px;
                background: linear-gradient(180deg, rgba(233, 240, 245, 0.8) 0%, #fff 100%);
                min-height: calc(100vh - 200px);
            }

            /* Container chính */
            .tour-content {
                max-width: 1200px;
                margin: 0 auto;
                background: #fff;
                border-radius: 15px;
                box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
                padding: 30px;
                transition: transform 0.3s ease;
            }
            .tour-content:hover {
                transform: translateY(-3px);
            }

            /* Tiêu đề tour */
            .tour-content h2 {
                color: #003087;
                font-size: 32px;
                font-weight: bold;
                text-align: center;
                margin-bottom: 30px;
                text-transform: uppercase;
                letter-spacing: 1px;
                position: relative;
            }
            .tour-content h2::after {
                content: '';
                width: 60px;
                height: 3px;
                background: #ff6200;
                position: absolute;
                bottom: -10px;
                left: 50%;
                transform: translateX(-50%);
            }

            /* Bố cục chi tiết tour */
            .tour-details {
                display: flex;
                flex-wrap: wrap;
                gap: 30px;
                margin-bottom: 20px;
            }
            .tour-details > div {
                flex: 1;
                min-width: 300px;
                background: #f9f9f9;
                padding: 20px;
                border-radius: 10px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
                transition: transform 0.3s ease, box-shadow 0.3s ease;
            }
            .tour-details > div:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            }

            /* Các mục thông tin */
            .info-item {
                display: flex;
                justify-content: space-between;
                padding: 10px 0;
                border-bottom: 1px solid #eee;
                font-size: 15px;
                color: #555;
            }
            .info-item:last-child {
                border-bottom: none;
            }
            .info-item strong {
                color: #003087;
                font-weight: 600;
            }
            .info-item img {
                max-width: 100%;
                height: auto;
                border-radius: 5px;
                margin-top: 10px;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            }

            /* Mô tả tour */
            .description {
                background: #f9f9f9;
                padding: 20px;
                border-radius: 10px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
                transition: transform 0.3s ease, box-shadow 0.3s ease;
            }
            .description:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            }

            /* Nút bấm */
            .btn-container {
                text-align: center;
                margin-top: 30px;
            }
            .btn {
                display: inline-block;
                padding: 12px 25px;
                border-radius: 25px;
                text-decoration: none;
                font-weight: bold;
                font-size: 15px;
                transition: background-color 0.3s ease, transform 0.2s ease;
                margin: 0 10px;
            }
            .btn:hover {
                transform: translateY(-2px);
            }
            .btn.back-btn {
                background-color: #007bff;
                color: #fff;
            }
            .btn.back-btn:hover {
                background-color: #0056b3;
            }
            .btn.btn-book-tour {
                background-color: #ff6200;
                color: #fff;
            }
            .btn.btn-book-tour:hover {
                background-color: #e55a00;
            }
            .btn.btn-share-tour {
                background-color: #28a745;
                color: #fff;
            }
            .btn.btn-share-tour:hover {
                background-color: #218838;
            }

            /* Thông báo lỗi */
            .error-message {
                color: #e74c3c;
                text-align: center;
                font-size: 18px;
                padding: 15px;
                background: #ffebee;
                border-radius: 5px;
                margin: 20px 0;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            }

            /* CSS cho toàn bộ trang */
            body {
                background-color: #f5f5f5;
                font-family: 'Arial', sans-serif;
            }

            /* CSS cho khu vực nội dung chính */
            .tour-content {
                max-width: 1200px;
                margin: 0 auto;
                background: #fff;
                border-radius: 15px;
                box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
                padding: 30px;
            }

            /* CSS cho phần danh sách đánh giá */
            .reviews-section {
                margin-top: 30px;
                padding: 20px;
                background-color: #fff;
                border-radius: 10px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            }

            .reviews-section h3 {
                text-align: center;
                color: #003087;
                font-size: 24px;
                margin-bottom: 20px;
            }

            .review {
                padding: 15px;
                border-bottom: 1px solid #dee2e6;
                margin-bottom: 15px;
            }

            .review:last-child {
                border-bottom: none;
            }

            .review .username {
                font-weight: bold;
                color: #000;
            }

            .review .rating {
                color: #ffc107;
                font-size: 18px;
                margin-left: 10px;
            }

            .review .comment {
                margin-top: 5px;
                color: #000;
                font-size: 16px;
            }

            .review .date {
                font-size: 14px;
                color: #999;
                margin-top: 5px;
            }

            /* CSS cho form thêm đánh giá */
            .add-review-form {
                margin-top: 30px;
                padding: 20px;
                background-color: #fff;
                border-radius: 10px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            }

            .add-review-form h3 {
                text-align: center;
                color: #003087;
                font-size: 24px;
                margin-bottom: 20px;
            }

            .add-review-form label {
                font-weight: bold;
                color: #003087;
                display: block;
                margin-bottom: 5px;
            }

            .add-review-form input,
            .add-review-form textarea {
                width: 100%;
                padding: 10px;
                margin-bottom: 15px;
                border: 1px solid #ced4da;
                border-radius: 5px;
                font-size: 16px;
            }

            .add-review-form button {
                display: block;
                width: 100%;
                padding: 12px;
                background-color: #28a745;
                color: #fff;
                border: none;
                border-radius: 5px;
                font-size: 16px;
                font-weight: bold;
                cursor: pointer;
                transition: background-color 0.3s ease;
            }

            .add-review-form button:hover {
                background-color: #218838;
            }

            /* CSS cho nút quay lại, đặt tour, chia sẻ */
            .btn {
                display: inline-block;
                padding: 12px 25px;
                border-radius: 25px;
                text-decoration: none;
                font-weight: bold;
                font-size: 15px;
                color: #fff;
                transition: background-color 0.3s ease;
                margin: 0 10px;
            }

            .btn.back-btn {
                background-color: #007bff;
            }

            .btn.back-btn:hover {
                background-color: #0056b3;
            }

            .btn.btn-book-tour {
                background-color: #ff6200;
            }

            .btn.btn-book-tour:hover {
                background-color: #e55a00;
            }

            .btn.btn-share-tour {
                background-color: #28a745;
            }

            .btn.btn-share-tour:hover {
                background-color: #218838;
            }

        </style>
    </head>
    <body class="changeHeader">
        <div id="wrap">
            <!-- Include the header JSP file to display the common header section -->
            <%@include file="/WEB-INF/inclu/head.jsp" %>

            <!-- Container for displaying tour details -->
            <div class="tour-container">
                <div class="tour-content">
                    <!-- Check if there is an error message to display -->
                    <% if (error != null) {%>
                    <!-- Display the error message -->
                    <p class="error-message"><%= error%></p>
                    <!-- If no error, check if the tour object exists -->
                    <% } else if (tour != null) {%>
                    <!-- Display the tour name, with a fallback if the name is null -->
                    <h2><%= tour.getName() != null ? tour.getName() : "Tên tour không có"%></h2>
                    <div class="tour-details">
                        <div>
                            <!-- Display the tour location, with a fallback if not available -->
                            <div class="info-item"><strong>Địa điểm:</strong> <span><%= tour.getLocation() != null ? tour.getLocation() : "Chưa cập nhật"%></span></div>
                            <!-- Display the mode of transport, with a fallback if not available -->
                            <div class="info-item"><strong>Phương tiện:</strong> <span><%= tour.getTransport() != null ? tour.getTransport() : "Chưa cập nhật"%></span></div>
                            <!-- Display the start date, with a fallback if not available -->
                            <div class="info-item"><strong>Bắt đầu:</strong> <span><%= tour.getStartDate() != null ? tour.getStartDate() : "Chưa cập nhật"%></span></div>
                            <!-- Display the end date, with a fallback if not available -->
                            <div class="info-item"><strong>Kết thúc:</strong> <span><%= tour.getEndDate() != null ? tour.getEndDate() : "Chưa cập nhật"%></span></div>
                            <!-- Display the price, with a fallback if not available or zero -->
                            <div class="info-item">
                                <strong>Giá:</strong> 
                                <span>
                                    <%= (tour.getPrice() != null && tour.getPrice().compareTo(BigDecimal.ZERO) != 0) ? tour.getPrice() + " VND" : "Chưa cập nhật"%>
                                </span>
                            </div>
                            <!-- Display the tour image if the image URL is available -->
                            <% if (tour.getImageUrl() != null && !tour.getImageUrl().isEmpty()) {%>
                            <div class="info-item"><img src="<%= tour.getImageUrl()%>" alt="Tour Image"></div>
                                <% }%>
                        </div>
                        <div class="description">
                            <!-- Display the tour description, with a fallback if not available -->
                            <div class="info-item"><strong>Mô tả:</strong> <span><%= tour.getDescription() != null ? tour.getDescription() : "Chưa có mô tả"%></span></div>
                        </div>
                    </div>
                    <!-- Buttons for navigation and actions -->
                    <div class="btn-container">
                        <!-- Link to return to the tour list -->
                        <a href="<%= request.getContextPath()%>/SortTour" class="btn back-btn">Quay lại danh sách</a>
                        <!-- Link to book the tour -->
                        <a href="<%= request.getContextPath()%>/booking?action=inputTour&id=<%= tour.getId()%>" class="btn btn-book-tour">Đặt Tour</a>
                        <!-- Button to share the tour, calling the shareTour function -->
                        <button class="btn btn-share-tour" onclick="shareTour('<%= request.getContextPath()%>/booking?action=viewTour&id=<%= tour.getId()%>')">Chia sẻ Tour</button>
                    </div>
                    <!-- If no tour is found, display an error message -->
                    <% } else { %>
                    <p class="error-message">Không tìm thấy tour nào.</p>
                    <% }%>
                </div>
            </div>

            <!-- Section for displaying customer reviews -->
            <div class="reviews-section">
                <!-- Heading for the reviews section -->
                <h3 class="text-center mb-4">Đánh giá của khách hàng</h3>
                <!-- Check if there are any reviews to display -->
                <% if (reviews != null && !reviews.isEmpty()) { %>
                <!-- Loop through each review in the reviews list -->
                <% for (Review review : reviews) {%>
                <div class="review">
                    <p>
                        <!-- Display the username of the reviewer -->
                        <span class="username"><%= review.getUsername()%></span> - 
                        <!-- Display the rating as stars -->
                        <span class="rating">
                            <!-- Display filled stars for the rating -->
                            <% for (int i = 0; i < review.getRating(); i++) { %>
                            ★
                            <% } %>
                            <!-- Display empty stars for the remaining rating -->
                            <% for (int i = review.getRating(); i < 5; i++) { %>
                            ☆
                            <% }%>
                        </span>
                    </p>
                    <!-- Display the review comment -->
                    <p class="comment"><%= review.getComment()%></p>
                    <!-- Display the date of the review -->
                    <p class="date"><small>Ngày: <%= review.getReviewDate()%></small></p>
                    <!-- Check if the logged-in user is the reviewer, to allow deletion -->
                    <% if (user != null && user.getId() == review.getUserId()) {%>
                    <div class="actions">
                        <!-- Form to delete the review -->
                        <form action="${pageContext.request.contextPath}/booking" method="post">
                            <!-- Hidden input to specify the action as 'deleteReview' -->
                            <input type="hidden" name="action" value="deleteReview">
                            <!-- Hidden input to pass the review ID -->
                            <input type="hidden" name="reviewId" value="<%= review.getId()%>">
                            <!-- Hidden input to pass the tour ID -->
                            <input type="hidden" name="tourId" value="<%= tour.getId()%>">
                            <!-- Button to submit the delete request -->
                            <button type="submit" class="text-danger" style="background:none; border:none; padding:0; cursor:pointer;">Xóa</button>
                        </form>
                    </div>
                    <% } %>
                </div>
                <% } %>
                <!-- If no reviews are available, display a message -->
                <% } else { %>
                <p class="text-center">Chưa có đánh giá nào cho tour này.</p>
                <% }%>
            </div>

            <!-- Check if the user is logged in and the tour exists to display the review form -->
            <% if (user != null && tour != null) {%>
            <div class="add-review-form">
                <!-- Heading for the add review section -->
                <h3 class="text-center mb-4">Thêm đánh giá của bạn</h3>
                <!-- Form to submit a new review -->
                <form action="<%= request.getContextPath()%>/booking" method="post">
                    <!-- Hidden input to specify the action as 'addReview' -->
                    <input type="hidden" name="action" value="addReview">
                    <!-- Hidden input to pass the tour ID -->
                    <input type="hidden" name="tourId" value="<%= tour.getId()%>">
                    <div class="mb-3">
                        <!-- Input field for the rating (1-5) -->
                        <label for="rating" class="form-label">Đánh giá (1-5):</label>
                        <input type="number" id="rating" name="rating" min="1" max="5" required class="form-control" placeholder="Nhập số từ 1 đến 5">
                        <!-- Feedback message for invalid rating input -->
                        <div class="invalid-feedback">Vui lòng nhập số từ 1 đến 5.</div>
                    </div>
                    <div class="mb-3">
                        <!-- Textarea for the review comment -->
                        <label for="comment" class="form-label">Bình luận:</label>
                        <textarea id="comment" name="comment" required class="form-control" rows="3" placeholder="Nhập bình luận của bạn"></textarea>
                        <!-- Feedback message for invalid comment input -->
                        <div class="invalid-feedback">Vui lòng nhập bình luận.</div>
                    </div>
                    <!-- Button to submit the review -->
                    <button type="submit" class="btn btn-success">Gửi đánh giá</button>
                </form>
            </div>
            <!-- If the user is not logged in, prompt them to log in -->
            <% } else { %>
            <p class="text-center">Bạn cần <a href="<%= request.getContextPath()%>/login" class="text-primary">đăng nhập</a> để đánh giá tour.</p>
            <% }%>

            <!-- Include the footer JSP file to display the common footer section -->
            <%@include file="/WEB-INF/inclu/footer.jsp" %>
        </div>
    </body>

    <script>
        function shareTour(url) {
            navigator.clipboard.writeText(url).then(() => {
                alert("Đã sao chép liên kết tour vào clipboard: " + url);
            }).catch(err => {
                console.error('Lỗi khi sao chép: ', err);
                alert("Không thể sao chép liên kết, vui lòng thử lại!");
            });
        }
        (function () {
            'use strict';
            var forms = document.querySelectorAll('.needs-validation');
            Array.prototype.slice.call(forms).forEach(function (form) {
                form.addEventListener('submit', function (event) {
                    if (!form.checkValidity()) {
                        event.preventDefault();
                        event.stopPropagation();
                    }
                    form.classList.add('was-validated');
                }, false);
            });
        })();
    </script>
</body>
</html>