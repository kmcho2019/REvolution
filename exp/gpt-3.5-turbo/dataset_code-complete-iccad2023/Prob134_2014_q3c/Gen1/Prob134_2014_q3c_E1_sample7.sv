module TopModule (
  input clk,
  input x,
  input [2:0] y,
  output reg Y0,
  output reg z
);

// Next state logic for Y[0]
always @*
begin
  Y0 = 1'b0; // Default assignment
  if (y == 3'b000 && x == 1'b0) Y0 = 1'b0;
  else if (y == 3'b000 && x == 1'b1) Y0 = 1'b1;
  else if (y == 3'b001 && x == 1'b0) Y0 = 1'b0;
  else if (y == 3'b001 && x == 1'b1) Y0 = 1'b0;
  else if (y == 3'b010 && x == 1'b0) Y0 = 1'b0;
  else if (y == 3'b010 && x == 1'b1) Y0 = 1'b1;
  else if (y == 3'b011 && x == 1'b0) Y0 = 1'b0;
  else if (y == 3'b011 && x == 1'b1) Y0 = 1'b0;
  else if (y == 3'b100 && x == 1'b0) Y0 = 1'b1;
  else if (y == 3'b100 && x == 1'b1) Y0 = 1'b0;
end

// Output logic for z
always @*
begin
  z = (y == 3'b011 || y == 3'b100) ? 1'b1 : 1'b0;
end

endmodule