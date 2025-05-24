<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>


<meta http-equiv="content-type" content="text/html;charset=UTF-8" />

<!-- SITE TITLE -->
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta property="fb:app_id" content="859491851234128"/>
<title>BookingTour - Home Page</title>
<meta property="og:type" content="website"/>
<meta property="og:title" content="CÔNG TY TNHH MỘT THÀNH VIÊN DỊCH VỤ LỮ HÀNH SAIGONTOURIST"/>
<meta property="og:url" content="index.html"/>
<meta property="og:description" content="đặt tour saigontourist"/>
<meta property="og:image" content="<%= request.getContextPath()%>/assets/img/logo-color-big.png"/>

<!-- Font Awesome CDN -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

<!-- Custom CSS -->
<style>
    #wrap {
        position: relative;
        background: #fff;
        min-height: 100vh;
        width: 100vw;
        max-width: 100%;
        overflow-x: hidden;
    }

    /* Header Styles */
    .header-top {
        background-color: #e9f0f5;
        padding: 5px 0;
        font-size: 14px;
        color: #333;
    }
    .header-top .container {
        display: flex;
        justify-content: space-between;
        align-items: center;
        max-width: 1200px;
        margin: 0 auto;
        padding: 0 15px;
    }
    .header-top .contact-info {
        display: flex;
        gap: 20px;
    }
    .header-top .contact-info a {
        color: #333;
        text-decoration: none;
    }
    .header-top .user-options {
        display: flex;
        gap: 15px;
    }
    .header-top .user-options a {
        color: #007bff;
        text-decoration: none;
        display: flex;
        align-items: center;
        gap: 5px;
    }
    .header-top .user-options a:hover {
        color: #0056b3;
    }

    /* Main Header with Logo and Menu */
    .header-main {
        background-color: rgba(0, 0, 0, 0.5);
        padding: 10px 0;
        border-bottom: 1px solid #ddd;
        position: absolute;
        width: 100%;
        z-index: 1000;
    }
    .header-main .container {
        display: flex;
        justify-content: space-between;
        align-items: center;
        max-width: 1200px;
        margin: 0 auto;
        padding: 0 15px;
    }
    .header-main .logo {
        margin-left: 0;
    }
    .header-main .logo img {
        height: 40px;
    }
    .header-main .main-menu ul {
        list-style: none;
        padding: 0;
        margin: 0;
        display: flex;
        gap: 20px; /* Tăng khoảng cách giữa các mục */
        margin-right: 20px; /* Thêm khoảng cách bên phải để không sát cạnh */
    }
    .header-main .main-menu ul li a {
        color: #fff;
        text-decoration: none;
        font-size: 14px;
        font-weight: bold;
        text-transform: uppercase;
        background-color: #003087; /* Màu xanh đậm */
        padding: 8px 15px;
        border-radius: 5px;
        transition: background-color 0.3s ease;
    }
    .header-main .main-menu ul li a:hover {
        background-color: #002766; /* Màu xanh đậm hơn khi hover */
    }

    /* Slider Styles */
    .slider-container {
        position: relative;
        width: 100%;
        height: 500px;
        overflow: hidden;
    }
    .slider {
        display: flex;
        width: 300%;
        height: 100%;
        animation: slide 9s infinite;
    }
    .slide {
        width: 33.33%;
        flex-shrink: 0;
        position: relative;
    }
    .slide img {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }
    @keyframes slide {
        0% {
            transform: translateX(0);
        }
        33.33% {
            transform: translateX(0);
        }
        33.34% {
            transform: translateX(-33.33%);
        }
        66.66% {
            transform: translateX(-33.33%);
        }
        66.67% {
            transform: translateX(-66.66%);
        }
        100% {
            transform: translateX(-66.66%);
        }
    }
    .slide-content {
        position: absolute;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        text-align: center;
        color: #fff;
        text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.5);
    }
    .slide-content h2 {
        font-size: 48px;
        font-weight: bold;
        margin-bottom: 10px;
        color: blueviolet black;
    }

    /* Banner Styles */
    .banner {
        margin: 20px 0;
        width: 100%;
        text-align: center;
    }
    .banner a {
        display: block;
    }
    .banner img {
        width: 100%;
        max-height: 250px;
        object-fit: cover;
        border-radius: 0;
    }

    /* Featured Tours Styles */
    .featured-tours {
        padding: 50px 0;
        background-color: #fff;
        width: 100%;
    }
    .container {
        max-width: 1200px;
        margin: 0 auto;
        padding: 0 15px;
    }
    .fix_title {
        text-align: left;
        margin-bottom: 20px;
        font-size: 24px;
        color: #0056b3;
        font-weight: bold;
        text-transform: uppercase;
    }
    .tours-list {
        display: flex;
        justify-content: space-between;
        flex-wrap: wrap;
        gap: 20px;
    }
    .tour-card {
        background: #fff;
        border-radius: 10px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        overflow: hidden;
        width: calc(33.33% - 14px);
        position: relative;
        transition: transform 0.3s ease;
    }
    .tour-card:hover {
        transform: translateY(-5px);
    }
    .tour-card img {
        width: 100%;
        height: 200px;
        object-fit: cover;
    }
    .tour-info {
        padding: 15px;
        text-align: left;
    }
    .tour-info .price-tag {
        position: absolute;
        top: 10px;
        left: 10px;
        background-color: #ff6200;
        color: #fff;
        padding: 5px 10px;
        border-radius: 5px;
        font-size: 14px;
        font-weight: bold;
    }
    .tour-info h3 {
        font-size: 16px;
        font-weight: bold;
        color: #333;
        margin-bottom: 5px;
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        overflow: hidden;
        text-overflow: ellipsis;
    }
    .tour-info p {
        font-size: 14px;
        color: #666;
        margin: 5px 0;
    }
    .tour-info .description {
        font-size: 13px;
        color: #888;
        margin-top: 5px;
        display: -webkit-box;
        -webkit-line-clamp: 3;
        -webkit-box-orient: vertical;
        overflow: hidden;
        text-overflow: ellipsis;
    }
    .tour-info .btn {
        margin-top: 10px;
        display: inline-block;
        background-color: #007bff;
        color: #fff;
        padding: 8px 15px;
        border-radius: 5px;
        text-decoration: none;
        transition: background-color 0.3s ease;
    }
    .tour-info .btn:hover {
        background-color: #0056b3;
    }

</style>

<!-- JAVASCRIPTS -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script type="text/javascript">
    $(document).ready(function () {
        locale = 'vi';
        loggedIn = false;
    });
</script>


<body class="changeHeader">
    <div id="wrap">
        <!-- HEADER -->
        <header id="header" class="header">
            <!-- Header Top -->
            <div class="header-top">
                <div class="container">
                    <div class="contact-info">
                        <a href="mailto:info@saigontourist.net"><i class="fa fa-envelope" aria-hidden="true"></i> info@saigontourist.net</a>
                        <a href="tel:19001808"><i class="fa fa-phone" aria-hidden="true"></i> Hotline: 1900 1808</a>
                    </div>
                    <div class="user-options">
                        <c:choose>
                            <c:when test="${not empty sessionScope.user}">
                                <a href="<%= request.getContextPath()%>/UserServlet"><i class="fa fa-user" aria-hidden="true"></i> Xin chào, ${sessionScope.user.fullName}!</a>
                                <a href="logout"><i class="fa fa-sign-out" aria-hidden="true"></i> Đăng xuất</a>
                            </c:when>
                            <c:otherwise>
                                <a href="login"><i class="fa fa-sign-in" aria-hidden="true"></i> Đăng nhập</a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <!-- Header Main -->
            <div class="header-main">
                <div class="container">
                    <div class="logo">
                        <a href="#"><img src="<%= request.getContextPath()%>/images/Logo_G3.png" alt="SaigonTourist Logo"></a>
                    </div>
                    <div class="main-menu">
                        <ul>
                            <li><a href="<%= request.getContextPath()%>/SortTour" >TRANG CHỦ</a></li>                               
                            <li><a href="#">LIÊN HỆ</a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </header>

        <!-- Slider Section -->
        <section class="slider-container">
            <div class="slider">
                <div class="slide">
                    <img src="<%= request.getContextPath()%>/images/TL.jpg" alt="Slide 1">
                    <div class="slide-content">
                        <h2>Khám Phá Thế Giới Cùng GR3</h2>
                    </div>
                </div>
                <div class="slide">
                    <img src="<%= request.getContextPath()%>/images/ChauAu.png" alt="Slide 2">
                    <div class="slide-content">
                        <h2>Khám Phá Thế Giới Cùng GR3</h2>
                    </div>
                </div>
                <div class="slide">
                    <img src="<%= request.getContextPath()%>/images/America.jpg" alt="Slide 3">
                    <div class="slide-content">
                        <h2>Khám Phá Thế Giới Cùng GR3</h2>
                    </div>
                </div>
            </div>
        </section>

        <!-- Banner Section -->
        <section class="banner">
            <a href="#"> <!-- Để bạn gắn link vào đây -->
                <img src="<%= request.getContextPath()%>/images/banner3.jpg" alt="Banner">
            </a>
        </section>

    </div>
</body>
