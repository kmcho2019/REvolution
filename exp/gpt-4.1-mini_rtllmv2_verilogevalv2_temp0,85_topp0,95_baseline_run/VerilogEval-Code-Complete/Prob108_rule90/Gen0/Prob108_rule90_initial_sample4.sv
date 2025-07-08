module TopModule (
  input clk,
  input load,
  input [511:0] data,
  output reg [511:0] q
);
  integer i;
  always @(posedge clk) begin
    if (load) begin
      q <= data;
    end else begin
      // Compute next state according to Rule 90:
      // q_next[i] = q[i-1] ^ q[i+1], with boundary cells zero outside.
      // Use a temporary variable to hold next state.
      reg [511:0] next_q;
      next_q[0] = 0 ^ q[1];            // Left boundary: q[-1] = 0
      for (i = 1; i < 511; i = i + 1) begin
        next_q[i] = q[i-1] ^ q[i+1];
      end
      next_q[511] = q[510] ^ 0;        // Right boundary: q[512] = 0
      q <= next_q;
    end
  end
endmodule