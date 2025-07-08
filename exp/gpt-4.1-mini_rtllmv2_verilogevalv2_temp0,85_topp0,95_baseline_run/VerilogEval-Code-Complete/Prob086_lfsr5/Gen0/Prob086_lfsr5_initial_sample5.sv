module TopModule (
  input clk,
  input reset,
  output reg [4:0] q
);

  always @(posedge clk) begin
    if (reset) begin
      q <= 5'b00001;
    end else begin
      // Calculate feedback bit: XOR q[0] with taps q[4] and q[2]
      wire feedback = q[0] ^ q[4] ^ q[2];
      // Shift right and insert feedback at MSB
      q <= {feedback, q[4:1]};
    end
  end

endmodule