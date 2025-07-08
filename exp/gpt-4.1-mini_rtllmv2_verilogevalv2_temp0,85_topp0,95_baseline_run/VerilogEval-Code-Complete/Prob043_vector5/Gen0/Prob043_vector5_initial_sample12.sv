module TopModule (
  input a,
  input b,
  input c,
  input d,
  input e,
  output [24:0] out
);
  wire [4:0] in_vec = {a,b,c,d,e};

  // Generate all pairwise comparisons: out[24] = in_vec[0] == in_vec[0], out[23] = in_vec[0] == in_vec[1], ..., out[0] = in_vec[4] == in_vec[4]
  genvar i, j;
  wire [24:0] cmp;
  generate
    for (i=0; i<5; i=i+1) begin: row
      for (j=0; j<5; j=j+1) begin: col
        assign cmp[24 - (5*i + j)] = ~(in_vec[i] ^ in_vec[j]);
      end
    end
  endgenerate

  assign out = cmp;

endmodule