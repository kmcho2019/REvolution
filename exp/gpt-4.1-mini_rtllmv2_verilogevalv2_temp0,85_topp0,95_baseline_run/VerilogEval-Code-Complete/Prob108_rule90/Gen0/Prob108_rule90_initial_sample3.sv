module TopModule (
  input clk,
  input load,
  input [511:0] data,
  output reg [511:0] q
);

  integer i;
  reg [511:0] next_q;

  always @(posedge clk) begin
    if (load) begin
      q <= data;
    end else begin
      // Compute next state for each cell
      // For cell i, next state = q[i-1] ^ q[i+1]
      // For boundaries, q[-1] = 0, q[512] = 0
      next_q[0] = q[1];                     // left neighbor is 0 ^ right neighbor q[1]
      next_q[511] = q[510];                 // left neighbor q[510] ^ right neighbor 0
      for (i = 1; i < 511; i = i + 1) begin
        next_q[i] = q[i-1] ^ q[i+1];
      end
      q <= next_q;
    end
  end

endmodule