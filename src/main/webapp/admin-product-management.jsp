<%@page import="java_ecommerce.hibernate.model.Category"%>
<%@page import="java_ecommerce.hibernate.dao.CategoryDao"%>
<%@page import="java_ecommerce.hibernate.model.Product"%>
<%@page import="java_ecommerce.hibernate.dao.ProductDao"%>
<%@page import="java.util.List"%>
<%@include file="components/admin-check.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Java-Ecommerce | Ürün Yönetimi</title>
</head>
<body>
	<div class="row">
		<div class="col-auto">
			<%@include file="components/navbar.jsp"%>
		</div>
		<div class="col">
			<div class="product-management-box">
				<%@include file="components/message.jsp"%>
				<%
				ProductDao productDao = new ProductDao();
				List<Product> productList = productDao.fetchAll();
				%>
				<div class="mb-2">
					<h5>
						Toplam ürün sayısı:
						<%=productList.size()%></h5>
				</div>
				<div class="row">
					<div class="col d-flex justify-content-end mb-3">
						<button type="button" class="btn btn-success" data-toggle="modal"
							data-target="#addProductModal">Ekle</button>
					</div>
				</div>

				<table class="table table-striped text-center">
					<thead>
						<tr>
							<th class="col-md-1" scope="col">#</th>
							<th class="col-md-2" scope="col">Ürün Resmi</th>
							<th class="col-md-1" scope="col">Ürün ID</th>
							<th class="col-md-2" scope="col">Ürün Adı</th>
							<th class="col-md-2" scope="col">Ürün Kategorisi</th>
							<th class="col-md-2" scope="col">Ürün Fiyatı</th>
							<th class="col-md-1" scope="col">Ürün Stok Adedi</th>
							<th class="col-md-1" scope="col"></th>
						</tr>
					</thead>
					<tbody class="product-table">
						<%
						for (int i = 0; i < productList.size(); i++) {
						%>
						<tr>
							<th class="text-truncate" style="max-width: 20px;" scope="row"><%=i + 1%></th>
							<td class="text-truncate" style="max-width: 20px;"><a href="product-detail.jsp?productid=<%=productList.get(i).getId()%>"><img
								src="img<%=productList.get(i).getImage()%>" width="200px"
								height="200px"></a></td>
							<th class="text-truncate" style="max-width: 20px;" scope="row">#<%=productList.get(i).getId()%></th>
							<td class="text-truncate" style="max-width: 20px;"><%=productList.get(i).getName()%></td>
							<td class="text-truncate" style="max-width: 20px;"><%=productList.get(i).getCategory().getName()%></td>
							<td class="text-truncate" style="max-width: 20px;"><%=productList.get(i).getPrice()%> TL</td>
							<td class="text-truncate" style="max-width: 20px;"><%=productList.get(i).getStock()%></td>
							<td>
								<div class="d-flex justify-content-end">
									<form action="admin-product-edit.jsp" method="get">
										<input type="hidden" value="<%=productList.get(i).getId()%>"
											name="productid" /> <input
											class="btn btn-sm btn-primary btn-block" id="editSubmit"
											type="submit" value="Düzenle" />
									</form>
									<form id="deleteForm<%=i + 1%>"
										action="ProductOperationServlet" method="post">
										<input type="hidden" name="operation" value="delete">
										<input type="hidden" name="productId"
											value="<%=productList.get(i).getId()%>">
									</form>
									<button class="btn btn-sm btn-danger btn-block ml-2"
										onclick="deleteProduct(<%=i + 1%>)">Sil</button>
								</div>
							</td>
						</tr>
						<%
						}
						%>
					</tbody>
				</table>
			</div>

			<!-- Add Category Modal -->

			<div class="modal fade" id="addProductModal" tabindex="-1"
				aria-labelledby="addProductModalLabel" aria-hidden="true"
				data-backdrop="static" data-keyboard="false">
				<div class="modal-dialog">
					<div class="modal-content">
						<div class="modal-header">
							<h5 class="modal-title" id="addProductModalLabel">Ürün Ekle</h5>
							<button type="button" class="close" data-dismiss="modal"
								aria-label="Close">
								<span aria-hidden="true">&times;</span>
							</button>
						</div>
						<div class="modal-body">

							<form action="ProductOperationServlet" method="post"
								enctype="multipart/form-data">
								<input type="hidden" name="operation" value="add">
								<div class="mb-3">
									<label for="productName">Ürün adı(*)</label> <input type="text"
										class="form-control mb-3" id="productName" name="productName"
										placeholder="Ürün adı" required> <label for="category">Kategorisi(*)</label>
									<div class="d-flex">
										<select name="category" class="form-control mb-3"
											id="category" required>
											<%
											CategoryDao categoryDao = new CategoryDao();
											List<Category> categoryList = categoryDao.fetchAll();
											for (Category category : categoryList) {
											%>
											<option value="<%=category.getId()%>"><%=category.getName()%></option>
											<%
											}
											%>
										</select>
									</div>
									
									<label for="productPrice">Fiyatı(*)</label> <input
										type="number" class="form-control mb-3" id="productPrice"
										name="productPrice" placeholder="Ürün fiyatı" required>
									<label for="productStock">Stok adedi(*)</label> <input
										type="number" class="form-control mb-3" id="productStock"
										name="productStock" placeholder="Stok adedi" required>
									<label for="productImage">Ürün resmini seçiniz</label><br>
									<input type="file" accept="image/png, image/jpeg"
										id="productImage" name="productImage" />
								</div>

								<div class="container text-center">
									<button type="button" class="btn btn-secondary"
										data-dismiss="modal">İptal</button>
									<input type="submit" class="btn btn-primary" value="Kaydet" />
								</div>
							</form>
						</div>
					</div>
				</div>
			</div>

			<!-- Add Category Modal End -->
		</div>
	</div>
	<%@include file="components/footer.jsp"%>
	<%@include file="components/links-scripts.jsp"%>

	<script>
		function deleteProduct(count){
			var result = confirm(count + " numaralı ürün silenecek. Onaylıyor musunuz?");
			if(result){
				var deleteForm = document.getElementById("deleteForm" + count);
				deleteForm.submit();
			}		
		}
	</script>

</body>

<style>
.product-management-box {
	background-color: #f5f5f5;
	border-radius: 10px;
	padding: 30px;
	margin: 30px;
}

.product-table td {
	vertical-align: middle;
}

.product-table th {
	vertical-align: middle;
}
</style>

</html>