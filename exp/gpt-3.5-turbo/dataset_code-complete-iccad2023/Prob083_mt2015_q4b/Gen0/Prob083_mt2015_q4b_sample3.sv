module TopModule (
  input x,
  input y,
  output z
);

reg x_reg, y_reg, z_reg;

initial begin
  x_reg = 0;
  y_reg = 0;
  z_reg = 1;
end

always begin
  #5 x_reg = 0;
  #5 y_reg = 0;
  #5 z_reg = 1;
  #5 x_reg = 1;
  #5 y_reg = 0;
  #5 z_reg = 0;
  #5 x_reg = 0;
  #5 y_reg = 1;
  #5 z_reg = 0;
  #5 x_reg = 1;
  #5 y_reg = 1;
  #5 z_reg = 1;
  #5 x_reg = 0;
  #5 y_reg = 0;
  #5 z_reg = 1;
  #5 x_reg = 0;
  #5 y_reg = 1;
  #5 z_reg = 0;
  #5 x_reg = 1;
  #5 y_reg = 1;
  #5 z_reg = 1;
  #5 x_reg = 0;
  #5 y_reg = 1;
  #5 z_reg = 0;
  #5 x_reg = 0;
  #5 y_reg = 1;
  #5 z_reg = 0;
  #5 x_reg = 1;
  #5 y_reg = 0;
  #5 z_reg = 0;
end

assign z = z_reg;

endmodule