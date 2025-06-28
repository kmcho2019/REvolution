module TopModule (
  input a,
  input b,
  input c,
  input d,
  input e,
  output [24:0] out
);
  
  reg [4:0] i, j;
  reg [24:0] pairwise_results;
  
  always @* begin
    for (i = 0; i < 5; i = i + 1) begin
      for (j = 0; j < 5; j = j + 1) begin
        pairwise_results[i*5 + j] = ~(i == j) ^ ({a,b,c,d,e}[i] == {a,b,c,d,e}[j]);
      end
    end
  end
  
  assign out = pairwise_results;
  
endmodule