module TopModule (
  input a,
  input b,
  input c,
  input d,
  input e,
  output [24:0] out
);

  wire [4:0] inputs = {a, b, c, d, e};
  integer i, j;
  reg [24:0] temp_out;

  always @(*) begin
    // Index mapping: out[24 - (5*i + j)] = inputs[i] XNOR inputs[j]
    for (i = 0; i < 5; i = i + 1) begin
      for (j = 0; j < 5; j = j + 1) begin
        temp_out[24 - (5*i + j)] = ~(inputs[i] ^ inputs[j]); // XNOR
      end
    end
  end

  assign out = temp_out;

endmodule