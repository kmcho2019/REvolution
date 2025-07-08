module Mux2(input sel, input i0, input i1, output y);
  assign y = sel ? i1 : i0;
endmodule

module TopModule(input c, input d, output [3:0] mux_in);

  // mux_in[0] = c OR d
  // Implement c OR d = mux2 with c as sel, i0=d, i1=1'b1
  wire one = 1'b1;
  Mux2 or_mux(.sel(c), .i0(d), .i1(one), .y(mux_in[0]));

  // mux_in[1] = 0
  assign mux_in[1] = 1'b0;

  // mux_in[2] = c & d
  // Implement c & d = mux2 with c as sel, i0=0, i1=d
  wire zero = 1'b0;
  Mux2 and_mux(.sel(c), .i0(zero), .i1(d), .y(mux_in[2]));

  // mux_in[3] = c + ~d
  // Implement ~d = mux2 with d as sel, i0=1, i1=0
  wire not_d;
  Mux2 not_d_mux(.sel(d), .i0(one), .i1(zero), .y(not_d));
  // Then mux_in[3] = mux2 with c as sel, i0=not_d, i1=1
  Mux2 final_mux(.sel(c), .i0(not_d), .i1(one), .y(mux_in[3]));

endmodule