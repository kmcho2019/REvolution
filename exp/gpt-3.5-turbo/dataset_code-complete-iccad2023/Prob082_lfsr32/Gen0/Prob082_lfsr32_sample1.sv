module TopModule (
  input clk,
  input reset,
  output reg [31:0] q
);

// Internal signals
reg [31:0] next_q;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    q <= 32'h1;
  end else begin
    next_q[0] = q[31] ^ q[0] ^ q[22] ^ q[2] ^ q[1]; // XOR taps at bit positions 32, 22, 2, and 1
    next_q[1:31] = q[0:30]; // Shift right
    q <= next_q;
  end
end

endmodule