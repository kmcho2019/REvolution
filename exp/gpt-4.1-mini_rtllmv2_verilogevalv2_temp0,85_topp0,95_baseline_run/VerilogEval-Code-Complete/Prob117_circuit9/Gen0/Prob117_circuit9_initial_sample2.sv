module TopModule (
  input clk,
  input a,
  output reg [2:0] q
);

  always @(posedge clk) begin
    if (a)
      q <= 3'd4;               // hold or reset q to 4 when a=1
    else
      q <= q + 3'd1;           // increment q when a=0
  end

endmodule