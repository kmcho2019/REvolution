module TopModule (
  input clk,
  input reset,
  output reg [31:0] q
);

  wire feedback = q[0];

  integer i;
  reg [31:0] next_q;

  always @(posedge clk) begin
    if (reset) begin
      q <= 32'h1;
    end else begin
      next_q[31] = q[31] ^ feedback;    // tap at bit 32 (q[31])
      next_q[21] = q[21] ^ feedback;    // tap at bit 22 (q[21])
      next_q[1]  = q[1]  ^ feedback;    // tap at bit 2  (q[1])
      next_q[0]  = feedback;             // LSB always is feedback (output bit)

      // For bits without taps, shift right from previous bit
      // We set them first to default shift before overriding taps
      for (i = 30; i >= 0; i = i - 1) begin
        next_q[i] = q[i+1];
      end

      // Override tapped bits already handled above:
      next_q[31] = q[31] ^ feedback;
      next_q[21] = q[21] ^ feedback;
      next_q[1]  = q[1]  ^ feedback;
      next_q[0]  = feedback;

      q <= next_q;
    end
  end

endmodule