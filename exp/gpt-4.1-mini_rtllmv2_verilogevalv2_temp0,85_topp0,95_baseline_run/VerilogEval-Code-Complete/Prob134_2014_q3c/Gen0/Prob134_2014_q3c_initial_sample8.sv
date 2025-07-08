module TopModule (
  input clk,
  input x,
  input [2:0] y,
  output reg Y0,
  output reg z
);

always @(*) begin
  // Default assignments
  Y0 = 0;
  z = 0;

  // Output z depends only on present state y
  case (y)
    3'b011, 3'b100: z = 1;
    default: z = 0;
  endcase

  // Next state Y0 depends on present state y and input x
  case ({y, x})
    {3'b000, 1'b0}: Y0 = 1'b0; // next state 000 -> Y0=0
    {3'b000, 1'b1}: Y0 = 1'b1; // next state 001 -> Y0=1
    {3'b001, 1'b0}: Y0 = 1'b1; // next state 001 -> Y0=1
    {3'b001, 1'b1}: Y0 = 1'b0; // next state 100 -> Y0=0
    {3'b010, 1'b0}: Y0 = 1'b0; // next state 010 -> Y0=0
    {3'b010, 1'b1}: Y0 = 1'b1; // next state 001 -> Y0=1
    {3'b011, 1'b0}: Y0 = 1'b1; // next state 001 -> Y0=1
    {3'b011, 1'b1}: Y0 = 1'b0; // next state 010 -> Y0=0
    {3'b100, 1'b0}: Y0 = 1'b1; // next state 011 -> Y0=1
    {3'b100, 1'b1}: Y0 = 1'b0; // next state 100 -> Y0=0
    default: Y0 = 1'b0;
  endcase
end

endmodule