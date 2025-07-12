module TopModule(c, d, mux_in);
  input c, d;
  output [3:0] mux_in;

  assign mux_in[0] = (c == 1'b0 && d == 1'b0) ? 1'b0 :
                     (c == 1'b1 && d == 1'b0) ? 1'b1 :
                     (c == 1'b1 && d == 1'b1) ? 1'b1 :
                     (c == 1'b0 && d == 1'b1) ? 1'b1 : 1'bx;

  assign mux_in[1] = (c == 1'b0 && d == 1'b0) ? 1'b0 :
                     (c == 1'b1 && d == 1'b0) ? 1'b0 :
                     (c == 1'b1 && d == 1'b1) ? 1'b0 :
                     (c == 1'b0 && d == 1'b1) ? 1'b0 : 1'bx;

  assign mux_in[2] = (c == 1'b0 && d == 1'b0) ? 1'b0 :
                     (c == 1'b1 && d == 1'b0) ? 1'b0 :
                     (c == 1'b1 && d == 1'b1) ? 1'b1 :
                     (c == 1'b0 && d == 1'b1) ? 1'b0 : 1'bx;

  assign mux_in[3] = (c == 1'b0 && d == 1'b0) ? 1'b1 :
                     (c == 1'b1 && d == 1'b0) ? 1'b0 :
                     (c == 1'b1 && d == 1'b1) ? 1'b1 :
                     (c == 1'b0 && d == 1'b1) ? 1'b1 : 1'bx;

endmodule