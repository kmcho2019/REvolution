module TopModule(c, d, mux_in);
  input c, d;
  output [3:0] mux_in;

  assign mux_in[0] = c; // ab = 00
  assign mux_in[1] = 1'b0; // ab = 01
  assign mux_in[2] = c ? d : d; // ab = 11
  assign mux_in[3] = d; // ab = 10

  // Replace the above 2 lines with 2-to-1 mux logic
  wire temp_out;
  assign temp_out = c ? d : d;
  assign mux_in[2] = temp_out;
  assign mux_in[3] = d;
endmodule