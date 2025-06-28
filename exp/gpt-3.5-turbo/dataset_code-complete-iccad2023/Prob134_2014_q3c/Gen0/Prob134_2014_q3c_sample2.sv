module TopModule (
  input clk,
  input x,
  input [2:0] y,
  output reg Y0,
  output reg z
);

// State assignment
parameter S0 = 3'b000;
parameter S1 = 3'b001;
parameter S2 = 3'b010;
parameter S3 = 3'b011;
parameter S4 = 3'b100;

// Declare state reg
reg [2:0] state_reg, next_state_reg;

// Next state logic
always @(*)
begin
  case({y, x})
    {S0, 1}: next_state_reg = S0;
    {S0, 0}: next_state_reg = S1;
    {S1, 1}: next_state_reg = S0;
    {S1, 0}: next_state_reg = S4;
    {S2, 1}: next_state_reg = S0;
    {S2, 0}: next_state_reg = S1;
    {S3, 1}: next_state_reg = S0;
    {S3, 0}: next_state_reg = S2;
    {S4, 1}: next_state_reg = S3;
    {S4, 0}: next_state_reg = S4;
  endcase
end

// State register
always @(posedge clk)
begin
  state_reg <= next_state_reg;
end

// Output logic
always @(*)
begin
  Y0 = (state_reg == S1) || (state_reg == S3);
  z = (state_reg == S3) || (state_reg == S4);
end

endmodule