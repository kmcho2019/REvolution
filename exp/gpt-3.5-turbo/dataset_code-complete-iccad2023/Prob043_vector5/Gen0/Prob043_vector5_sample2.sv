module TopModule (
  input a,
  input b,
  input c,
  input d,
  input e,
  output [24:0] out
);

  // Create 25-bit output vector
  reg [24:0] out;

  always @* begin
    integer i, j;
    for (i = 0; i < 5; i = i + 1) begin
      for (j = 0; j < 5; j = j + 1) begin
        out[i*5 + j] = ~(i == j) ^ ({a, b, c, d, e}[i] == {a, b, c, d, e}[j]);
      end
    end
  end

endmodule