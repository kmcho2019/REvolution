module TopModule (
  input  a,
  input  b,
  input  c,
  input  d,
  input  e,
  output [24:0] out
);
  // Store inputs in an array for easy indexing
  wire [4:0] inputs = {a, b, c, d, e};

  genvar i, j;
  // Temporary wire to hold the outputs before assignment to out
  wire [24:0] temp_out;

  generate
    // Index for output bits: from 24 down to 0
    // out[24 - (i*5 + j)] = ~inputs[i] ^ inputs[j]
    for (i = 0; i < 5; i = i + 1) begin : outer
      for (j = 0; j < 5; j = j + 1) begin : inner
        assign temp_out[24 - (i*5 + j)] = (~inputs[i]) ^ inputs[j];
      end
    end
  endgenerate

  assign out = temp_out;

endmodule