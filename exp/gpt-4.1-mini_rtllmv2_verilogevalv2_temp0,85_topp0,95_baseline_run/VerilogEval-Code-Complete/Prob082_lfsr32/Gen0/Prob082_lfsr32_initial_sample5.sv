module TopModule (
  input clk,
  input reset,
  output reg [31:0] q
);
  // taps: bit positions 32, 22, 2, 1
  // index in q: 31, 21, 1, 0 (0-based)
  always @(posedge clk) begin
    if (reset) begin
      q <= 32'h1;
    end else begin
      // feedback is LSB before shift
      wire feedback = q[0];
      // next bits:
      // q[31] = q[31] xor feedback (tap at 32)
      // q[21] = q[21] xor feedback (tap at 22)
      // q[1]  = q[1]  xor feedback (tap at 2)
      // q[0]  shifts out, replaced by q[1]
      q <= {q[30] ^ feedback, 
            q[29:22], 
            q[21] ^ feedback,
            q[20:2], 
            q[1]  ^ feedback,
            q[0]};
      // But this concatenation is complicated. 
      // Better to assign bit by bit:
    end
  end

  // Rewriting with bit-by-bit approach in a combinational fashion:
  // But since q is reg, we can create a wire for next_q
  wire feedback = q[0];
  wire [31:0] next_q;

  assign next_q[31] = q[31] ^ feedback; // tap 32
  assign next_q[30] = q[31];
  assign next_q[29:22] = q[30:23];
  assign next_q[21] = q[21] ^ feedback; // tap 22
  assign next_q[20:2] = q[20:2];
  assign next_q[1] = q[1] ^ feedback;  // tap 2
  assign next_q[0] = q[1];             // shift right
  
  always @(posedge clk) begin
    if (reset) 
      q <= 32'h1;
    else 
      q <= next_q;
  end
endmodule