module TopModule (
  input c,
  input d,
  output [3:0] mux_in
);

// 2-to-1 mux module definition
function automatic mux2to1;
  input sel, in0, in1;
  begin
    mux2to1 = sel ? in1 : in0;
  end
endfunction

// mux_in[0] = d ? 1 : c
assign mux_in[0] = mux2to1(d, c, 1'b1);

// mux_in[1] = 0
assign mux_in[1] = 1'b0;

// mux_in[2] = d ? c : 0
assign mux_in[2] = mux2to1(d, 1'b0, c);

// mux_in[3] = d ? c : 1
assign mux_in[3] = mux2to1(d, 1'b1, c);

endmodule