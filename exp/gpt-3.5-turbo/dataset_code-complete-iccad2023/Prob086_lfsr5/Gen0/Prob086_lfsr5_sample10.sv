module TopModule (
  input clk,
  input reset,
  output reg [4:0] q
);

reg [4:0] next_q;

always @(posedge clk or posedge reset)
begin
  if (reset)
    q <= 5'b00001; // Initial value after reset (all-ones except LSB)
  else
    q <= next_q;
end

always @(*)
begin
  next_q[0] = q[3] ^ q[0]; // Feedback XOR for tap position 3
  next_q[1] = q[0];
  next_q[2] = q[1];
  next_q[3] = q[2] ^ q[0]; // Feedback XOR for tap position 5
  next_q[4] = q[3] ^ q[2] ^ q[1] ^ q[0]; // Feedback XOR for tap position 5
end

endmodule