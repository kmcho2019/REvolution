module TopModule (
  input clk,
  input L,
  input q_in,
  input r_in,
  input q_in_2, // Additional input for the bit needed in XOR operation
  output reg Q
);

  always @(posedge clk) begin
    if (L) begin
      Q <= r_in;
    end else begin
      if (q_in_2 == 1'b1) begin
        // Perform XOR with q_in_2 when it is valid (for the middle bit)
        Q <= q_in ^ q_in_2;
      end else begin
        // No change when q_in_2 is not valid (for LSB and MSB)
        Q <= q_in;
      end
    end
  end
endmodule