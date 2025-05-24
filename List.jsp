<%--
    Document   : List
    Created on : Mar 7, 2025, 8:09:55 PM
    Author     : ACER
--%>

<%@page import="model.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.Tour" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    List<Tour> tours = (List<Tour>) request.getAttribute("tours");
    Integer currentPageObj = (Integer) request.getAttribute("currentPage");
    Integer totalPagesObj = (Integer) request.getAttribute("totalPages");
    String filter = (String) request.getAttribute("filter");
    String sort = (String) request.getAttribute("sort");
    User user = (User) session.getAttribute("user");

    int currentPage = (currentPageObj != null) ? currentPageObj : 1;
    int totalPages = (totalPagesObj != null) ? totalPagesObj : 1;
%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <%@include file="/WEB-INF/inclu/header.jsp" %>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>DANH SÁCH TOURIST</title>

        <!-- CSS Plugins from header.jsp -->
        <link href="<%= request.getContextPath()%>/assets/plugins/bootstrap/css/bootstrap.min.css" rel="stylesheet">
        <link href="<%= request.getContextPath()%>/assets/plugins/font-awesome/css/font-awesome.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css?family=Montserrat:100,100i,200,200i,300,300i,400,400i,500,500i,600,600i,700,700i,800,800i,900,900i&subset=vietnamese" rel="stylesheet">
        <link href="<%= request.getContextPath()%>/assets/css/style5059.css?v=20" rel="stylesheet">
        <link rel="stylesheet" href="<%= request.getContextPath()%>/assets/css/colors/default.css" id="option_color">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

        <!-- Custom Styles -->
        <style>
            .controls {
                margin: 20px 0;
                text-align: center;
                display: flex;
                justify-content: center;
                align-items: center;
                gap: 10px;
            }
            .controls button, .controls input, .controls select {
                margin: 0 10px;
                padding: 8px 15px;
                border-radius: 5px;
                font-family: 'Montserrat', sans-serif;
            }
            .controls button, .controls select {
                background-color: #007bff;
                color: #fff;
                border: none;
                transition: background-color 0.3s ease;
            }
            .controls button:hover, .controls select:hover {
                background-color: #0056b3;
            }
            .trip-container {
                padding: 30px 0;
            }
            .trip-info {
                background: #fff;
                border-radius: 10px;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
                margin-bottom: 20px;
                overflow: hidden;
                transition: transform 0.3s ease;
            }
            .trip-info:hover {
                transform: translateY(-10px);
            }
            .trip-image img {
                width: 100%;
                height: 200px;
                object-fit: cover;
            }
            .trip-image .logo {
                position: absolute;
                top: 10px;
                left: 10px;
                background: rgba(0, 0, 0, 0.7);
                color: #fff;
                padding: 5px 10px;
                border-radius: 3px;
                font-size: 12px;
            }
            .trip-details {
                padding: 15px;
            }
            .trip-details h1 {
                font-size: 18px;
                font-weight: bold;
                margin-bottom: 10px;
            }
            .trip-details h1 a {
                color: #333;
                text-decoration: none;
            }
            .trip-details h1 a:hover {
                color: #007bff;
            }
            .trip-details p {
                margin: 5px 0;
                color: #666;
                font-size: 14px;
            }
            .tour-type {
                font-size: 14px;
                color: #28a745;
                font-weight: bold;
            }
            .price-date {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-top: 10px;
            }
            .price-date span {
                font-size: 16px;
                color: #007bff;
            }
            .dates button {
                background: #f8f9fa;
                border: 1px solid #ddd;
                padding: 5px 10px;
                margin-left: 5px;
                border-radius: 3px;
                font-size: 12px;
            }
            .trip-details form button {
                background-color: #28a745;
                color: #fff;
                border: none;
                padding: 8px 15px;
                border-radius: 5px;
                margin-top: 10px;
            }
            .trip-details form button:hover {
                background-color: #218838;
            }
            .pagination {
                text-align: center;
                margin: 20px 0;
            }
            .pagination a {
                padding: 10px 15px;
                margin: 0 5px;
                text-decoration: none;
                background-color: #007bff;
                color: white;
                font-weight: bold;
                border-radius: 5px;
                transition: background-color 0.3s ease;
            }
            .pagination a:hover {
                background-color: #0056b3;
            }
            .pagination a.active {
                background-color: #28a745;
                border: 2px solid #218838;
            }
            .no-data {
                text-align: center;
                color: #e74c3c;
                font-size: 18px;
                margin-top: 20px;
            }



         
        </style>
    </head>

    <body>
        <!-- Section for Featured Tours -->
        <section class="featured-tours">
            <div class="container">
                <!-- Heading for the featured tours section -->
                <h2 class="fix_title">Tour Nổi Bật</h2>
                <div class="tours-list">
                    <!-- Tour 1: Ha Noi - Ha Long 3N2D -->
                    <div class="tour-card">
                        <!-- Tour image with a fallback in case of loading error -->
                        <img src="<%= request.getContextPath()%>/images/NB1.jpg" alt="Ha Noi - Ha Long 3N2D" onError="this.onerror=null; this.src='<%= request.getContextPath()%>/assets/img/default-tour.jpg';">
                        <div class="tour-info">
                            <!-- Display the price of the tour -->
                            <span class="price-tag">5,000,000đ</span>
                            <!-- Tour title -->
                            <h3>Ha Noi - Ha Long 3N2D</h3>
                            <!-- Tour location -->
                            <p><strong>Địa điểm:</strong> Ha Long</p>
                            <!-- Tour duration -->
                            <p><strong>Thời gian:</strong> 2025-02-01 - 2025-02-03</p>
                            <!-- Mode of transport -->
                            <p><strong>Phương tiện:</strong> Xe khách</p>
                            <!-- Short description of the tour -->
                            <p class="description">Tour tham quan vịnh Hạ Long 3 ngày 2 đêm</p>
                            <!-- Link to view tour details -->
                            <a href="<%= request.getContextPath()%>/booking?action=viewTour&id=1" class="btn">Chi tiết</a>
                        </div>
                    </div>
                    <!-- Tour 2: Sai Gon - Phu Quoc 4N3D -->
                    <div class="tour-card">
                        <!-- Tour image with a fallback in case of loading error -->
                        <img src="<%= request.getContextPath()%>/images/Nb2.jpg" alt="Sai Gon - Phu Quoc 4N3D" onError="this.onerror=null; this.src='<%= request.getContextPath()%>/assets/img/default-tour.jpg';">
                        <div class="tour-info">
                            <!-- Display the price of the tour -->
                            <span class="price-tag">7,000,000đ</span>
                            <!-- Tour title -->
                            <h3>Sai Gon - Phu Quoc 4N3D</h3>
                            <!-- Tour location -->
                            <p><strong>Địa điểm:</strong> Phu Quoc</p>
                            <!-- Tour duration -->
                            <p><strong>Thời gian:</strong> 2025-03-01 - 2025-03-04</p>
                            <!-- Mode of transport -->
                            <p><strong>Phương tiện:</strong> Máy bay</p>
                            <!-- Short description of the tour -->
                            <p class="description">Tour nghỉ dưỡng tại Phú Quốc 4 ngày 3 đêm</p>
                            <!-- Link to view tour details -->
                            <a href="<%= request.getContextPath()%>/booking?action=viewTour&id=2" class="btn">Chi tiết</a>
                        </div>
                    </div>
                    <!-- Tour 3: Da Nang - Hoi An 3N2D -->
                    <div class="tour-card">
                        <!-- Tour image with a fallback in case of loading error -->
                        <img src="<%= request.getContextPath()%>/images/NB3.jpg" alt="Da Nang - Hoi An 3N2D" onError="this.onerror=null; this.src='<%= request.getContextPath()%>/assets/img/default-tour.jpg';">
                        <div class="tour-info">
                            <!-- Display the price of the tour -->
                            <span class="price-tag">4,000,000đ</span>
                            <!-- Tour title -->
                            <h3>Da Nang - Hoi An 3N2D</h3>
                            <!-- Tour location -->
                            <p><strong>Địa điểm:</strong> Hoi An</p>
                            <!-- Tour duration -->
                            <p><strong>Thời gian:</strong> 2025-04-01 - 2025-04-03</p>
                            <!-- Mode of transport -->
                            <p><strong>Phương tiện:</strong> Xe du lịch</p>
                            <!-- Short description of the tour -->
                            <p class="description">Khám phá phố cổ Hội An và biển Mỹ Khê</p>
                            <!-- Link to view tour details -->
                            <a href="<%= request.getContextPath()%>/booking?action=viewTour&id=3" class="btn">Chi tiết</a>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <div class="container">
            <!-- Controls for filtering, sorting, and searching tours -->
            <div class="controls">
                <!-- Dropdown to filter tours by type (All, Domestic, International) -->
                <select onchange="filterTours(this.value)">
                    <option value="" <%= (filter == null || filter.isEmpty()) ? "selected" : ""%>>Tất cả</option>
                    <option value="Trong nước" <%= "Trong nước".equals(filter) ? "selected" : ""%>>Trong nước</option>
                    <option value="Ngoài nước" <%= "Ngoài nước".equals(filter) ? "selected" : ""%>>Ngoài nước</option>
                </select>
                <!-- Button to sort tours by price in ascending order -->
                <button onclick="sortToursByPrice(true)">Giá tăng dần</button>
                <!-- Button to sort tours by price in descending order -->
                <button onclick="sortToursByPrice(false)">Giá giảm dần</button>
                <!-- Search input to filter tours by keyword -->
                <input type="text" id="searchInput" placeholder="Search..." onkeyup="searchTours()">
                <!-- Button to reset the search and filters -->
                <button onclick="resetSearch()">🔄 Reset</button>
            </div>

            <!-- Container to display the list of tours -->
            <div class="trip-container">
                <!-- Check if the tours list is not null and not empty -->
                <% if (tours != null && !tours.isEmpty()) { %>
                <!-- Loop through each tour in the tours list -->
                <% for (Tour tour : tours) {%>
                <div class="trip-info">
                    <div class="trip-image">
                        <!-- Display the tour image with a fallback in case of loading error -->
                        <img src="<%= tour.getImageUrl()%>" alt="Hình ảnh tour" onError="this.onerror=null; this.src='<%= request.getContextPath()%>/images/default-tour.jpg';">
                        <!-- Display a logo on the tour image -->
                        <span class="logo">GR3</span>
                    </div>
                    <div class="trip-details">
                        <!-- Tour name with a link to view details -->
                        <h1>
                            <a href="booking?action=viewTour&id=<%= tour.getId()%>"><%= tour.getName()%></a>
                        </h1>
                        <!-- Tour location -->
                        <p><b><%= tour.getLocation()%></b></p>
                        <!-- Mode of transport -->
                        <p>Phương tiện: <strong><%= tour.getTransport()%></strong></p>
                        <!-- Tour type (Domestic or International) -->
                        <p class="tour-type">Loại tour: <strong><%= "Domestic".equals(tour.getType()) ? "Trong nước" : "Ngoài nước"%></strong></p>
                        <div class="price-date">
                            <!-- Display the tour price -->
                            <span>Giá từ: <strong><%= tour.getPrice()%> VND</strong></span>
                            <div class="dates">
                                <!-- Display the start date -->
                                <button><%= tour.getStartDate()%></button>
                                <!-- Display the end date -->
                                <button><%= tour.getEndDate()%></button>
                            </div>
                        </div>
                        <!-- Form to view the tour details -->
                        <form action="<%= request.getContextPath()%>/booking" method="GET">
                            <input type="hidden" name="action" value="viewTour">
                            <input type="hidden" name="id" value="<%= tour.getId()%>">
                            <button type="submit">Xem Tour</button>
                        </form>
                       <% if (user != null && "Admin".equals(user.getUserRole())) {%>
                        <a href="<%= request.getContextPath()%>/admineditTour?id=<%= tour.getId()%>" class="btn btn-edit">Sửa</a>
                        <a href="<%= request.getContextPath()%>/admindeleteTour?id=<%= tour.getId()%>" class=" btn btn-delete" onclick="return confirm('Xác nhận xóa tour?')">Xóa</a>
                        <% } %>
                    </div>
                </div>
                <% } %>
                <!-- If no tours are available, display a message -->
                <% } else { %>
                <p class="no-data">Không có tour nào để hiển thị.</p>
                <% }%>
            </div>

            <!-- Pagination controls for navigating through tour pages -->
            <div class="pagination">
                <!-- Display pagination links if there is more than one page -->
                <% if (totalPages > 1) { %>
                <!-- Link to the previous page if not on the first page -->
                <% if (currentPage > 1) {%>
                <a href="SortTour?filter=<%= filter != null ? filter : ""%>&sort=<%= sort != null ? sort : "priceAsc"%>&page=<%= currentPage - 1%>">« Trang trước</a>
                <% } %>
                <!-- Loop through each page number to create pagination links -->
                <% for (int i = 1; i <= totalPages; i++) {%>
                <a href="SortTour?filter=<%= filter != null ? filter : ""%>&sort=<%= sort != null ? sort : "priceAsc"%>&page=<%= i%>" class="<%= (i == currentPage) ? "active" : ""%>"><%= i%></a>
                <% } %>
                <!-- Link to the next page if not on the last page -->
                <% if (currentPage < totalPages) {%>
                <a href="SortTour?filter=<%= filter != null ? filter : ""%>&sort=<%= sort != null ? sort : "priceAsc"%>&page=<%= currentPage + 1%>">Trang sau »</a>
                <% } %>
                <% }%>
            </div>
        </div>
    </body>
    <%@include file="/WEB-INF/inclu/footer.jsp" %>
    <!-- JavaScript from header.jsp -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="<%= request.getContextPath()%>/assets/plugins/bootstrap/js/bootstrap.min.js"></script>
    <script src="<%= request.getContextPath()%>/assets/js/custom5059.js?v=20"></script>
    <script src="<%= request.getContextPath()%>/assets/script.js"></script>
    <script>
                               function filterTours(filterValue) {
                                   const sort = '<%= sort != null ? sort : "priceAsc"%>';
                                   const page = '<%= currentPage%>';
                                   window.location.href = '<%= request.getContextPath()%>/SortTour?filter=' + encodeURIComponent(filterValue) + '&sort=' + sort + '&page=' + page;
                               }

                               function sortToursByPrice(ascending) {
                                   const filter = '<%= filter != null ? filter : ""%>';
                                   const sort = ascending ? 'priceAsc' : 'priceDesc';
                                   window.location.href = '<%= request.getContextPath()%>/SortTour?filter=' + encodeURIComponent(filter) + '&sort=' + sort + '&page=1';
                               }

                               function searchTours() {
                                   const input = document.getElementById('searchInput').value.toLowerCase();
                                   const trips = document.getElementsByClassName('trip-info');
                                   for (let i = 0; i < trips.length; i++) {
                                       const title = trips[i].getElementsByTagName('h1')[0].innerText.toLowerCase();
                                       const location = trips[i].getElementsByTagName('p')[0].innerText.toLowerCase();
                                       if (title.includes(input) || location.includes(input)) {
                                           trips[i].style.display = '';
                                       } else {
                                           trips[i].style.display = 'none';
                                       }
                                   }
                               }

                               function resetSearch() {
                                   document.getElementById('searchInput').value = '';
                                   const trips = document.getElementsByClassName('trip-info');
                                   for (let i = 0; i < trips.length; i++) {
                                       trips[i].style.display = '';
                                   }
                               }
    </script>
</body>
</html>