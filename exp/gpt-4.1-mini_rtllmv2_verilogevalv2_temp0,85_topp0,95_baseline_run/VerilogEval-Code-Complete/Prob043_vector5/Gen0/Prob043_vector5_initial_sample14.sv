module TopModule (
  input a,
  input b,
  input c,
  input d,
  input e,
  output [24:0] out
);

  // Define an array of inputs to simplify indexing
  wire [4:0] inputs = {a, b, c, d, e};

  // The output bits are assigned as out[24] for (a,a) down to out[0] for (e,e)
  // Index pairs (i,j) where i,j from 0 to 4 correspond to inputs[i] and inputs[j]
  // out[24 - (5*i + j)] = XNOR(inputs[i], inputs[j])

  genvar i, j;
  generate
    for (i = 0; i < 5; i = i + 1) begin : row_loop
      for (j = 0; j < 5; j = j + 1) begin : col_loop
        assign out[24 - (5*i + j)] = ~(inputs[i] ^ inputs[j]);
      end
    end
  endgenerate

endmodule