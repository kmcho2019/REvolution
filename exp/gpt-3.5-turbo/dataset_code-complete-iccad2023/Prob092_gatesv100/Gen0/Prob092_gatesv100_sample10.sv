module TopModule (
  input [99:0] in,
  output [98:0] out_both,
  output [99:1] out_any,
  output [99:0] out_different
);

  // out_both logic
  assign out_both = in[1:99] & in[0:98];
  
  // out_any logic
  assign out_any[99:1] = in[0:98] | in[1:99];
  
  // out_different logic
  assign out_different = in ^ {in[99], in[0:98]};
  
endmodule