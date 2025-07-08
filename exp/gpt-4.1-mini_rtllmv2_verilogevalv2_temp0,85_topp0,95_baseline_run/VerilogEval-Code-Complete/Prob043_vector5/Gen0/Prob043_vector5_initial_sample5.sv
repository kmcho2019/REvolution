module TopModule (
  input a,
  input b,
  input c,
  input d,
  input e,
  output [24:0] out
);
  wire [4:0] inputs;
  assign inputs = {a,b,c,d,e};

  genvar i, j;
  generate
    for (i = 0; i < 5; i = i + 1) begin : outer
      for (j = 0; j < 5; j = j + 1) begin : inner
        // Calculate bit index: bit 24 corresponds to (0,0), down to bit 0 corresponds to (4,4)
        // index = 24 - (i*5 + j)
        localparam integer idx = 24 - (i*5 + j);
        assign out[idx] = ~(inputs[i] ^ inputs[j]);
      end
    end
  endgenerate
endmodule