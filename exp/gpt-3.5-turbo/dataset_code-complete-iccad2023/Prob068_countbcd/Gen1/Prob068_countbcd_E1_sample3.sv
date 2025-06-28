module BCD_Counter (
  input clk,
  input reset,
  input [3:0] ena,
  output [15:0] q
);

reg [3:0] digit0, digit1, digit2, digit3;

always @ (posedge clk or posedge reset) begin
  if (reset) begin
    digit0 <= 4'b0000;
    digit1 <= 4'b0000;
    digit2 <= 4'b0000;
    digit3 <= 4'b0000;
  end else begin
    if (ena[0])
      digit0 <= (digit0 == 4'b1001) ? 4'b0000 : digit0 + 1;
    if (ena[1])
      digit1 <= (digit1 == 4'b1001) ? 4'b0000 : digit1 + 1;
    if (ena[2])
      digit2 <= (digit2 == 4'b1001) ? 4'b0000 : digit2 + 1;
    digit3 <= (digit3 == 4'b1001) ? 4'b0000 : digit3 + 1;
  end
end

assign q = {digit3, digit2, digit1, digit0};

endmodule