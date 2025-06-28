module TopModule (
  input clk,
  input reset,
  output reg [4:0] q
);

always @(posedge clk or posedge reset) begin
  if (reset) begin
    q <= 5'b1; // Reset LFSR output to 1
  end else begin
    q[0] <= q[4] ^ q[2]; // Calculate next state for LSB by XORing tap positions 5 and 3
    q[1] <= q[0]; // Shift right
    q[2] <= q[1]; // Shift right
    q[3] <= q[2]; // Shift right
    q[4] <= q[3]; // Shift right
  end
end

endmodule