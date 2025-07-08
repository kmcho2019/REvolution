module TopModule (
  input clk,
  input reset,
  output reg [31:0] q
);
  always @(posedge clk) begin
    if (reset) begin
      q <= 32'h1;
    end else begin
      // Calculate feedback bit as XOR of q[0] with taps q[31], q[21], q[1], q[0]
      // But taps are at bits 32, 22, 2, 1 which correspond to q[31], q[21], q[1], q[0]
      // Feedback bit = q[0] ^ q[31] ^ q[21] ^ q[1]
      wire feedback = q[0] ^ q[31] ^ q[21] ^ q[1];
      // Shift right by one and insert feedback at MSB
      q <= {feedback, q[31:1]};
    end
  end
endmodule