<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, model.AdminBooking" %>
<%@page import="java.text.NumberFormat, java.util.Locale"%>
<%
    NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
    Object totalRevenueObj = request.getAttribute("totalRevenue");

    String formattedRevenue = "0 VND"; // Giá trị mặc định nếu không có doanh thu
    if (totalRevenueObj != null) {
        try {
            double totalRevenue = Double.valueOf(totalRevenueObj.toString()); // ✅ Dùng Double.valueOf thay vì parseDouble
            formattedRevenue = currencyFormat.format(totalRevenue) + " VND"; // ✅ Chỉ format ở đây
        } catch (Exception e) {
            formattedRevenue = "Không hợp lệ";
        }
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Revenue Report</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">


        <style>
            /* Tổng thể */
            body {
                background: linear-gradient(135deg, #74ebd5, #acb6e5);
                font-family: 'Poppins', sans-serif;
                color: #333;
            }

            /* Container chính */
            .container {
                background: rgba(255, 255, 255, 0.9);
                padding: 30px;
                border-radius: 12px;
                margin-top: 40px;
                box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
                backdrop-filter: blur(10px);
                transition: all 0.3s ease-in-out;
            }

            .container:hover {
                transform: translateY(-5px);
                box-shadow: 0 12px 25px rgba(0, 0, 0, 0.2);
            }

            /* Tiêu đề */
            h2 {
                font-weight: bold;
                color: #2c3e50;
                text-transform: uppercase;
                letter-spacing: 1px;
            }

            /* Bảng dữ liệu */
            .table {
                border-radius: 8px;
                overflow: hidden;
            }

            .table th {
                text-align: center;
                background: linear-gradient(135deg, #007bff, #0056b3);
                color: white;
                padding: 14px;
                font-size: 16px;
            }

            .table td {
                text-align: center;
                vertical-align: middle;
                padding: 12px;
                font-size: 14px;
                font-weight: 500;
            }

            .table tbody tr {
                transition: all 0.3s ease-in-out;
            }

            .table tbody tr:hover {
                background-color: rgba(0, 123, 255, 0.1);
                transform: scale(1.02);
            }

            /* Ô input và select */
            .form-control, .form-select {
                border-radius: 8px;
                height: 45px;
                border: 2px solid #ced4da;
                transition: all 0.3s ease-in-out;
            }

            .form-control:focus, .form-select:focus {
                border-color: #007bff;
                box-shadow: 0 0 8px rgba(0, 123, 255, 0.5);
            }

            /* Nút bấm */
            .btn-primary {
                width: 100%;
                font-weight: bold;
                text-transform: uppercase;
                background: linear-gradient(135deg, #007bff, #004085);
                border: none;
                padding: 12px;
                border-radius: 8px;
                transition: all 0.3s ease-in-out;
                box-shadow: 0 4px 10px rgba(0, 123, 255, 0.3);
            }

            .btn-primary:hover {
                background: linear-gradient(135deg, #0056b3, #003366);
                transform: scale(1.05);
            }

            /* Nút "Tất cả" */
            .btn-secondary {
                background: linear-gradient(135deg, #6c757d, #343a40);
                border: none;
                padding: 12px;
                border-radius: 8px;
                font-weight: bold;
                color: white;
                transition: all 0.3s ease-in-out;
                box-shadow: 0 4px 10px rgba(108, 117, 125, 0.3);
            }

            .btn-secondary:hover {
                background: linear-gradient(135deg, #495057, #212529);
                transform: scale(1.05);
                box-shadow: 0 6px 15px rgba(108, 117, 125, 0.5);
            }

            /* Nút "Back" */
            /* Nút "Back" đặt ở góc trái dưới */
            .btn-back {
                position: fixed;
                bottom: 20px;
                left: 20px;
                background: linear-gradient(135deg, #ff7e5f, #ff3f34);
                border: none;
                padding: 12px 20px;
                border-radius: 8px;
                font-weight: bold;
                color: white;
                transition: all 0.3s ease-in-out;
                box-shadow: 0 4px 10px rgba(255, 63, 52, 0.3);
                text-transform: uppercase;
                z-index: 1000;
            }

            .btn-back:hover {
                background: linear-gradient(135deg, #e63946, #c0392b);
                transform: scale(1.1);
                box-shadow: 0 6px 15px rgba(255, 63, 52, 0.5);
            }

            /* Hiệu ứng Responsive */
            @media (max-width: 768px) {
                .container {
                    padding: 20px;
                }

                .btn-primary, .btn-secondary {
                    font-size: 14px;
                    padding: 10px;
                }

                .form-control, .form-select {
                    height: 40px;
                }
            }

        </style>
    </head>
    <body>
        <div class="container">
            <h2 class="mb-4 text-center">Doanh Thu</h2>

            <!-- Revenue filter form -->
            <form action="<%=request.getContextPath()%>/AdminStatisticsServlet" method="GET" class="row g-3">
                <input type="hidden" name="type" value="revenueDetails">


                <div class="col-md-3">
                    <label for="month" class="form-label">Tháng:</label>
                    <input type="number" id="month" name="month" class="form-control" required min="1" max="12">
                </div>

                <div class="col-md-3">
                    <label for="year" class="form-label">Năm:</label>
                    <input type="number" id="year" name="year" class="form-control" required min="2000" max="2100">
                </div>

                <div class="col-md-3">
                    <label for="tourType" class="form-label">Loại:</label>
                    <select id="tourType" name="tourType" class="form-select">
                        <option value="Domestic" <%= "Domestic".equals(request.getAttribute("tourType")) ? "selected" : ""%>>Trong nước</option>
                        <option value="International" <%= "International".equals(request.getAttribute("tourType")) ? "selected" : ""%>>Ngoài nước</option>
                    </select>

                </div>

                <div class="col-md-3 d-flex align-items-end">
                    <button type="submit" class="btn btn-primary">Lọc</button>
                    <a href="<%=request.getContextPath()%>/AdminStatisticsServlet?type=revenueAll" class="btn btn-secondary ms-2">All</a>
                </div>
            </form>


            <!-- Revenue table -->
            <table class="table table-bordered mt-4">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Khách hàng</th>
                        <th>Số điện thoại</th>
                        <th>Email</th>
                        <th>Ngày khởi hành</th>
                        <th>Địa điểm</th>
                        <th>Giá </th>
                        <th>Tổng tiền </th>
                        <th>Trạng thái</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        List<AdminBooking> revenueDetails = (List<AdminBooking>) request.getAttribute("revenueDetails");
                        if (revenueDetails != null && !revenueDetails.isEmpty()) {
                            for (AdminBooking booking : revenueDetails) {
                    %>
                    <tr>
                        <td><%= booking.getId()%></td>
                        <td><%= booking.getCustomerName()%></td>
                        <td><%= booking.getPhone()%></td>
                        <td><%= booking.getEmail()%></td>
                        <td><%= booking.getDeparture()%></td>
                        <td><%= booking.getDestination()%></td>
                        <td><%= currencyFormat.format(booking.getPrice())%> VND</td>
                        <td><%= currencyFormat.format(booking.getTotalAmount())%> VND</td>
                        <td><%= booking.getPaymentStatus()%></td>
                    </tr>
                    <% }
                    } else {%>
                    <tr>
                        <td colspan="9" class="text-center text-danger">⚠️ Không có dữ liệu doanh thu cho tháng <%= request.getAttribute("month")%> năm <%= request.getAttribute("year")%></td>
                    </tr>
                    <% }%>
                    <% if (request.getAttribute("totalRevenue") != null) { %>

                    <% } %>

                </tbody>

            </table>
            <!-- Show total revenue below table -->
            <% if (totalRevenueObj != null) {%>
            <div class="alert alert-info text-center mt-3">
                <strong>Tổng doanh thu tháng <%= request.getAttribute("month")%> năm <%= request.getAttribute("year")%>:</strong>
                <%= formattedRevenue%>
            </div>
            <% }%>
        </div>
        <a href="<%= request.getContextPath()%>/Admin/admin.jsp" class="btn btn-back">
            <i class="fas fa-arrow-left"></i> 
        </a>


    </body>
</html>
