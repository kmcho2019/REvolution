module TopModule (
  input a,
  input b,
  input c,
  input d,
  output q
);

  reg [3:0] input_count;
  
  always @* begin
    input_count = a + b + c + d;
    
    if (input_count >= 2)
      q = 1;
    else
      q = 0;
  end

endmodule