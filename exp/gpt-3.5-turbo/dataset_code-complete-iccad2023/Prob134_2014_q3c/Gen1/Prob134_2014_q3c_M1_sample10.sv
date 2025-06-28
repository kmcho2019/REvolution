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
    6'b000000: Y0 = 1'b0; // Present state: 000, x=0
    6'b000001: Y0 = 1'b1; // Present state: 000, x=1
    6'b001001: Y0 = 1'b0; // Present state: 001, x=1
    6'b001100: Y0 = 1'b1; // Present state: 001, x=0
    6'b010000: Y0 = 1'b0; // Present state: 010, x=0
    6'b010001: Y0 = 1'b1; // Present state: 010, x=1
    6'b011001: Y0 = 1'b0; // Present state: 011, x=1
    6'b011010: Y0 = 1'b1; // Present state: 011, x=0
    6'b100011: Y0 = 1'b1; // Present state: 100, x=1
    6'b100100: Y0 = 1'b1; // Present state: 100, x=0
    default: Y0 = 1'b0;
  endcase
end

// Output logic for z
always @*
begin
  case(y)
    3'b011: z = 1'b1; // Present state: 011
    3'b100: z = 1'b1; // Present state: 100
    default: z = 1'b0;
  endcase
end

endmodule