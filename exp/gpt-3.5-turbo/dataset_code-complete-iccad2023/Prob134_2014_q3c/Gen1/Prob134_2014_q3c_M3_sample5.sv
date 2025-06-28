module TopModule (
  input clk,
  input x,
  input [2:0] y,
  output reg Y0,
  output reg z
);

// State transition and output mapping based on the state-assigned table
always @(*)
begin
  // State transitions for Y[0]
  case(y)
    3'b000: Y0 = (x == 1) ? 1'b0 : 1'b1;  // Next state Y[0] for present state 000
    3'b001: Y0 = (x == 1) ? 1'b0 : 1'b0;  // Next state Y[0] for present state 001
    3'b010: Y0 = (x == 1) ? 1'b0 : 1'b0;  // Next state Y[0] for present state 010
    3'b011: Y0 = (x == 1) ? 1'b0 : 1'b1;  // Next state Y[0] for present state 011
    3'b100: Y0 = (x == 1) ? 1'b1 : 1'b0;  // Next state Y[0] for present state 100
    default: Y0 = 1'b0; // Default case
  endcase

  // Output z mapping
  case(y)
    3'b011: z = 1'b1;  // Output z for present state 011
    3'b100: z = 1'b1;  // Output z for present state 100
    default: z = 1'b0; // Default case
  endcase
end

endmodule