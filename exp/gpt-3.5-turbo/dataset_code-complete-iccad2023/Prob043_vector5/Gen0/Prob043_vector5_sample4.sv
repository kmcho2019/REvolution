module TopModule (
  input a,
  input b,
  input c,
  input d,
  input e,
  output [24:0] out
);
  
  reg [24:0] output;

  always @* begin
    // Perform pairwise one-bit comparisons
    for (int i = 0; i < 5; i = i + 1) begin
      for (int j = 0; j < 5; j = j + 1) begin
        output[i*5 + j] = (i == j) ? 1'b1 : (i == j) ? 1'b0 : 1'b1;
      end
    end
  end

  assign out = output;

endmodule