module TopModule (
  input clk,
  input a,
  input b,
  output reg [1:0] state,
  output reg [1:0] q
);

always @(posedge clk) begin
  q <= {a ^ b, a};
  state <= {q[1] ^ q[0], q[1]};
end

endmodule