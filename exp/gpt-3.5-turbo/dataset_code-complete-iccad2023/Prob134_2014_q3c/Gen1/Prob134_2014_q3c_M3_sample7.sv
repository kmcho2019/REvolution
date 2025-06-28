module TopModule (
  input clk,
  input x,
  input [2:0] y,
  output reg Y0,
  output reg z
);

// State transition logic for Y[0]
always @*
begin
  case({y, x})
    6'b000_0: Y0 = 1'b0;
    6'b000_1: Y0 = 1'b1;
    6'b001_0: Y0 = 1'b0;
    6'b001_1: Y0 = 1'b1;
    6'b010_0: Y0 = 1'b0;
    6'b011_0: Y0 = 1'b0;
    6'b100_0: Y0 = 1'b1;
    default: Y0 = 1'b0;
  endcase
end

// Output logic for z
always @*
begin
  case(y)
    3'b011: z = 1'b1;
    3'b100: z = 1'b1;
    default: z = 1'b0;
  endcase
end

endmodule