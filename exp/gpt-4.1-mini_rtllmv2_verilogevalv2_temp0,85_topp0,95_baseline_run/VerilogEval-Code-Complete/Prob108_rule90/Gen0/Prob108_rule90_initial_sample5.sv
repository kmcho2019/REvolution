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
      next_q[0] = q[1];                   // left neighbor is 0, right neighbor is q[1], so 0 XOR q[1] = q[1]
      next_q[511] = q[510];              // left neighbor is q[510], right neighbor is 0, so q[510] XOR 0 = q[510]
      for (i = 1; i < 511; i = i + 1) begin
        next_q[i] = q[i-1] ^ q[i+1];
      end
      q <= next_q;
    end
  end
endmodule