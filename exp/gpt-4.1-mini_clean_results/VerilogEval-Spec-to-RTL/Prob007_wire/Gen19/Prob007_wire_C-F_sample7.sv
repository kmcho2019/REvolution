module TopModule(input wire in, output wire out);
  // Direct continuous assignment mimicking WirePassThrough functionality,
  // but without extra module instantiation or interface overhead.
  assign out = in;
endmodule