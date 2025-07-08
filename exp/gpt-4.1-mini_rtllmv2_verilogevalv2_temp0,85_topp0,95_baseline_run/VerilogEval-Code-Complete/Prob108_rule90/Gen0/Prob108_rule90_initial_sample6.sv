module TopModule (
  input clk,
  input load,
  input [511:0] data,
  output reg [511:0] q
);
  reg [511:0] next_q;

  integer i;
  always @(*) begin
    // Boundary bits with zero neighbors
    next_q[0] = q[1];              // q[-1] = 0, so q[-1] XOR q[1] = 0 XOR q[1] = q[1]
    next_q[511] = q[510];          // q[512] = 0, so q[510] XOR 0 = q[510]
    // Internal bits
    for (i = 1; i < 511; i = i + 1) begin
      next_q[i] = q[i-1] ^ q[i+1];
    end
  end

  always @(posedge clk) begin
    if (load)
      q <= data;
    else
      q <= next_q;
  end

endmodule