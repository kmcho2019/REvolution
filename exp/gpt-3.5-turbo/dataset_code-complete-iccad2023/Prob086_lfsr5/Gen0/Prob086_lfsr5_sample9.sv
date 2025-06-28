module TopModule (
  input clk,
  input reset,
  output reg [4:0] q
);

reg [4:0] next_q;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    q <= 5'b1; // Reset LFSR output to 1
  end
  else begin
    next_q[4] <= q[3] ^ q[4]; // XOR tap positions 5 and 3 with q[0] to generate next state
    next_q[3] <= q[2];
    next_q[2] <= q[1];
    next_q[1] <= q[0];
    next_q[0] <= q[3] ^ q[4]; // XOR tap positions 5 and 3 with q[0]

    q <= next_q;
  end
end

endmodule