module DFF_with_reset (
  input clk,
  input reset,
  input d,
  output reg q
);

always @(negedge clk or posedge reset)
begin
  if (reset)
    q <= 8'h34; // Load initial value 0x34 on reset
  else
    q <= d;
end

endmodule

module TopModule (
  input clk,
  input [7:0] d,
  input reset,
  output reg [7:0] q
);

DFF_with_reset DFFs [7:0] (
  .clk(clk),
  .reset(reset),
  .d(d),
  .q(q)
);

endmodule