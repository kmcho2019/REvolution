module TopModule(input a, input b, output reg out);
  reg xor_ab;
  
  always @(*) begin
    xor_ab = a ^ b;
    out = ~xor_ab;
  end
endmodule