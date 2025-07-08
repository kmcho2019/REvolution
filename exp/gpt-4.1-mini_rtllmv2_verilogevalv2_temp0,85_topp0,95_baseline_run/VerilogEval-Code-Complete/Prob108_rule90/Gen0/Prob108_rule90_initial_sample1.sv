module TopModule (
  input clk,
  input load,
  input [511:0] data,
  output reg [511:0] q
);
  always @(posedge clk) begin
    if (load) begin
      q <= data;
    end else begin
      // Pad q with zeros at boundaries
      // extended_q = {0, q, 0}
      // next_q[i] = extended_q[i] ^ extended_q[i+2]
      // for i in 0 to 511
      q <= ({1'b0, q[510:0]} ^ {q[510:0], 1'b0});
    end
  end
endmodule