module TopModule (
  input clk,
  input a,
  output reg [2:0] q
);
  always @(posedge clk) begin
    if (a)
      q <= 3'd4;           // Hold q at 4 when a is 1
    else
      q <= (q == 3'd6) ? 3'd0 : q + 3'd1;  // Increment modulo 7 when a is 0
  end
endmodule