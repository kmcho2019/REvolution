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
    6'b000000, 6'b001001, 6'b010010: Y0 = 1'b0;
    6'b000001, 6'b100100: Y0 = 1'b1;
    6'b000011: Y0 = 1'b0;
    6'b001001, 6'b010010: Y0 = 1'b1;
    6'b011001: Y0 = 1'b0;
    6'b100011: Y0 = 1'b1;
    default: Y0 = 1'b0;
  endcase
end

// Output logic for z
always @*
begin
  case(y)
    3'b011, 3'b100: z = 1'b1;
    default: z = 1'b0;
  endcase
end

endmodule