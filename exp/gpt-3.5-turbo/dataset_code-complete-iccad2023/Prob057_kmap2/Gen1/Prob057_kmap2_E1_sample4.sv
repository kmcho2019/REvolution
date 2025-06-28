module TopModule (
  input a,
  input b,
  input c,
  input d,
  output out
);

// Intermediate outputs based on smaller Karnaugh maps
wire inter_out_1 = (a & b) | (~a & c);
wire inter_out_2 = (b & c) | (c & ~d) | (~a & b);
wire inter_out_3 = (a & b & ~c) | (a & c & d);

// Final output derived from intermediate outputs
assign out = inter_out_1 | inter_out_2 | inter_out_3;

endmodule