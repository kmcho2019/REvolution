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
    6'b00000_0: Y0 = 1'b0;  // y=000, x=0
    6'b00001_0: Y0 = 1'b0;  // y=001, x=0
    6'b00010_0: Y0 = 1'b1;  // y=010, x=0
    6'b00011_0: Y0 = 1'b0;  // y=011, x=0
    6'b00100_0: Y0 = 1'b1;  // y=100, x=0
    6'b00101_0: Y0 = 1'b0;  // default case for x=0
    6'b00000_1: Y0 = 1'b0;  // y=000, x=1
    6'b00100_1: Y0 = 1'b0;  // y=100, x=1
    6'b00001_1: Y0 = 1'b0;  // y=001, x=1
    6'b00011_1: Y0 = 1'b1;  // y=011, x=1
    6'b00110_1: Y0 = 1'b0;  // default case for x=1
    default: Y0 = 1'b0;  // default case
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