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
  case({y, x})
    3'b000 : Y0 = 1'b0;
    3'b001 : Y0 = x;
    3'b010 : Y0 = 1'b0;
    3'b011 : Y0 = 1'b0;
    3'b100 : Y0 = 1'b1;
    default : Y0 = 1'b0;
  endcase
end

// Output logic for z
always @*
begin
  case(y)
    3'b011 : z = 1'b1;
    3'b100 : z = 1'b1;
    default : z = 1'b0;
  endcase
end

endmodule