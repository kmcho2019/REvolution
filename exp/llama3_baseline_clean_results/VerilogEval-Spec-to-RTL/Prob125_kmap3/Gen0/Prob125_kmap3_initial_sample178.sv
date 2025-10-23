module TopModule(a, b, c, d, out);
  input a, b, c, d;
  output out;

  assign out = (c & (a | b)) | (!c & b);
endmodule