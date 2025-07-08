module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

// 2-to-1 multiplexer: sel=selector; in0=if sel=0; in1=if sel=1
function mux2;
    input sel, in0, in1;
    begin
        mux2 = sel ? in1 : in0;
    end
endfunction

// mux_in[0] = mux(d, c, 1)
assign mux_in[0] = mux2(d, c, 1'b1);

// mux_in[1] = 0
assign mux_in[1] = 1'b0;

// mux_in[2] = mux(d, 0, c)
assign mux_in[2] = mux2(d, 1'b0, c);

// mux_in[3] = mux(d, 1, c)
assign mux_in[3] = mux2(d, 1'b1, c);

endmodule