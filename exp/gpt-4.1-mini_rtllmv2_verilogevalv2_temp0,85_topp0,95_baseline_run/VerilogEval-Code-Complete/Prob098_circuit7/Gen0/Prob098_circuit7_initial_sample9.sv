module TopModule (
  input clk,
  input a,
  output reg q
);

  initial q = 0;

  always @(posedge clk) begin
    q <= q & (~a);
  end

endmodule