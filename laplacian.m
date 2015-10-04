function [nodes, elements, u, u_exact, err_l2] = laplacian(h)

  % parameters:
  l_x = 1;
  l_y = 1;

  n_el_x = round(l_x / h);
  n_el_y = round(l_y / h);

  %rhs_f = @(x) (- 4) * ones(size(x, 1), 1);
  %u_exact_f = @(x) x(:, 1).^2 + x(:, 2).^2;

  rhs_f = @(x) -(2 + x(:,1).^2 + x(:,2).^2) .* exp((x(:,1).^2 + x(:,2).^2) ./ 2);
  u_exact_f = @(x) exp((x(:,1).^2 + x(:,2).^2) ./ 2);

  % elementary integrals of basis functions:
  ints = elementary_integrals();


  % create a square regular mesh:
  mesh = build_square_mesh(l_x, l_y, n_el_x, n_el_y);


  % assemble the matrix and rhs:
  mat = assemble_p1_laplacian_matrix(mesh, ints);
  rhs = assemble_p1_rhs(mesh, ints, rhs_f);


  % set boundary conditions
  [mat, rhs] = set_boundary_conditions(mesh, mat, rhs, u_exact_f, mesh.boundary_nodes);

  % solve the linear system:
  u = linsolve(mat, rhs);
  u_exact = u_exact_f(mesh.nodes);

  % return the L_2 error:
  err_l2 = error_l2(mesh, u, u_exact_f);

  % return the mesh
  nodes = mesh.nodes;
  elements = mesh.elements;
end
