module TopModule (
  input a,
  input b,
  input c,
  input d,
  input e,
  output [24:0] out
);
  wire [4:0] in_bits = {a, b, c, d, e};

  // We'll map the outputs as follows:
  // Index i = 5 * row + col, where row and col index inputs 0 to 4 (a to e)
  // out[24] corresponds to (~a) ^ a (row=0, col=0)
  // out[23] corresponds to (~a) ^ b (row=0, col=1)
  // ...
  // out[0] corresponds to (~e) ^ e (row=4, col=4)

  genvar row, col;
  generate
    for (row = 0; row < 5; row = row + 1) begin : gen_row
      for (col = 0; col < 5; col = col + 1) begin : gen_col
        // Calculate index in out vector
        localparam idx = 24 - (row * 5 + col);
        // Compare ~in_bits[row] with in_bits[col]
        assign out[idx] = ~((~in_bits[row]) ^ in_bits[col]);
      end
    end
  endgenerate

endmodule