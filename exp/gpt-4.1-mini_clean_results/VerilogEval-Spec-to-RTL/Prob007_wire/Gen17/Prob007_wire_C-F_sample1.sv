module TopModule (
  input  wire in,
  output wire out
);
  // Direct continuous assignment inside module with generate syntax for future scalability
  generate
    assign out = in;
  endgenerate
endmodule