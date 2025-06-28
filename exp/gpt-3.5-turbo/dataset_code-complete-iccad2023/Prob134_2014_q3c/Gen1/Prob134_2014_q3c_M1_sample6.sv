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
    6'b000_00: Y0 = 1'b0; // Y[2:1] when x=0
    6'b000_01: Y0 = 1'b1; // Y[2:1] when x=1
    6'b001_00: Y0 = 1'b0;
    6'b001_01: Y0 = 1'b0;
    6'b010_00: Y0 = 1'b1;
    6'b010_01: Y0 = 1'b1;
    6'b011_00: Y0 = 1'b0;
    6'b011_01: Y0 = 1'b1;
    6'b100_00: Y0 = 1'b0;
    6'b100_01: Y0 = 1'b0;
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