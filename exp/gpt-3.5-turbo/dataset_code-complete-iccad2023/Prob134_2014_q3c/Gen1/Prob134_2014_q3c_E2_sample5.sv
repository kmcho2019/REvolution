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
    3'b000_0: Y0 = 1'b0; // Present state: 000, x=0
    3'b000_1: Y0 = 1'b1; // Present state: 000, x=1
    3'b001_0: Y0 = 1'b1; // Present state: 001, x=0
    3'b001_1: Y0 = 1'b0; // Present state: 001, x=1
    3'b010_0: Y0 = 1'b0; // Present state: 010, x=0
    3'b010_1: Y0 = 1'b1; // Present state: 010, x=1
    3'b011_0: Y0 = 1'b0; // Present state: 011, x=0
    3'b011_1: Y0 = 1'b0; // Present state: 011, x=1
    3'b100_0: Y0 = 1'b1; // Present state: 100, x=0
    3'b100_1: Y0 = 1'b0; // Present state: 100, x=1
    default: Y0 = 1'b0; // Default assignment
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