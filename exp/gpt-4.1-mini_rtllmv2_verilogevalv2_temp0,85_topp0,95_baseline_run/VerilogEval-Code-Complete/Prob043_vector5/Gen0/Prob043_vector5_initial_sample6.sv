module TopModule (
  input a,
  input b,
  input c,
  input d,
  input e,
  output [24:0] out
);

  wire [4:0] bits = {a,b,c,d,e};

  genvar i, j;
  generate
    for (i=0; i<5; i=i+1) begin : loop_i
      for (j=0; j<5; j=j+1) begin : loop_j
        // Calculate output bit index: 24 - (5*i + j)
        assign out[24 - (5*i + j)] = ~(bits[i] ^ bits[j]);
      end
    end
  endgenerate

endmodule