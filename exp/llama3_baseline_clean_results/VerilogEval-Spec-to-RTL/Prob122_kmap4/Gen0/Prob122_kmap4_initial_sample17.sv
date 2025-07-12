module TopModule(a, b, c, d, out);
  input a, b, c, d;
  output out;

  assign out = ((~c & ~d & (a ^ b)) | 
                (c & ~d & ((~a & ~b) | (a & b))) | 
                (~c & d & ((~a & ~b) | (a & b))) | 
                (c & d & (a ^ b)));

endmodule