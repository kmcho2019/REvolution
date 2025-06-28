module TopModule (
  input c,
  input d,
  output [3:0] mux_in
);

  wire m0, m1, m2, m3;

  // Simplifying the Karnaugh map entries
  assign m0 = ~c & (~d);
  assign m1 = c & ~d;
  assign m2 = c | ~d;
  assign m3 = c | d;

  // Connecting the outputs of the 2-to-1 multiplexers to 4-to-1 multiplexer's inputs
  assign mux_in = {m0, m1, m2, m3};

endmodule