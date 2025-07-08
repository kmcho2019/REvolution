module TopModule (
  input a,
  input b,
  input c,
  input d,
  input e,
  output [24:0] out
);
  wire [4:0] inputs = {a,b,c,d,e};
  // Indexing: out[24 - (5*row + col)] = ~(inputs[row] ^ inputs[col])
  // So out[24] = ~(a ^ a), out[23] = ~(a ^ b), ..., out[0] = ~(e ^ e)

  genvar row, col;
  generate
    for(row=0; row<5; row=row+1) begin: ROWS
      for(col=0; col<5; col=col+1) begin: COLS
        // Calculate bit position in out
        localparam integer bit_pos = 24 - (5*row + col);
        assign out[bit_pos] = ~(inputs[row] ^ inputs[col]);
      end
    end
  endgenerate
endmodule