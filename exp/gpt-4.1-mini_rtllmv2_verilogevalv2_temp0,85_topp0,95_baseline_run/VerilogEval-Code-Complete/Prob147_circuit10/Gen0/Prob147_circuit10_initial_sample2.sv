module TopModule (
  input clk,
  input a,
  input b,
  output reg q,
  output state
);

  assign state = q;

  always @(posedge clk) begin
    q <= (q & ~(a & b)) | (~q & b);
  end

endmodule