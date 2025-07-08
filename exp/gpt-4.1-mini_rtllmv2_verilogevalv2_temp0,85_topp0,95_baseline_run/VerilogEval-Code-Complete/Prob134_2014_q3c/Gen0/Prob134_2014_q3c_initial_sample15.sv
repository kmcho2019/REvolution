module TopModule (
  input clk,
  input x,
  input [2:0] y,
  output reg Y0,
  output reg z
);

wire next_Y0_x0, next_Y0_x1;

// Define next_Y0 for x=0 based on present state y
// Using combinational logic or case statement
// From table for x=0:
assign next_Y0_x0 = 
    (y == 3'b001) ? 1'b1 :
    (y == 3'b011) ? 1'b1 :
    (y == 3'b100) ? 1'b1 :
    1'b0;

// For x=1:
assign next_Y0_x1 =
    (y == 3'b000) ? 1'b1 :
    (y == 3'b010) ? 1'b1 :
    1'b0;

// z=1 if y=011 or y=100
wire z_val = (y == 3'b011) || (y == 3'b100);

always @(*) begin
    z = z_val;
    // Select next_Y0 according to x
    Y0 = x ? next_Y0_x1 : next_Y0_x0;
end

endmodule