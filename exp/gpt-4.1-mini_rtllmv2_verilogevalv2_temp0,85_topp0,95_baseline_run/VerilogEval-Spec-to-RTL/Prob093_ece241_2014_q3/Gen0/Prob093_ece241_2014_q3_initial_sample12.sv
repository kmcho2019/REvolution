module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

// 2-to-1 mux function
// MUX2(sel, in0, in1) = sel ? in1 : in0
function mux2;
    input sel, in0, in1;
    begin
        mux2 = sel ? in1 : in0;
    end
endfunction

// mux_in[0]: for ab=00
// c as selector:
// if c=0: output = d ? 1 : 0
// if c=1: output = 1
assign mux_in[0] = mux2(c, mux2(d, 0, 1), 1);

// mux_in[1]: for ab=01
// constant 0
assign mux_in[1] = 1'b0;

// mux_in[2]: for ab=10
// d as selector:
// if d=0: output = 1
// if d=1: output = c ? 1 : 0
assign mux_in[2] = mux2(d, 1'b1, mux2(c, 1'b0, 1'b1));

// mux_in[3]: for ab=11
// c as selector:
// if c=0: output = 0
// if c=1: output = d ? 1 : 0
assign mux_in[3] = mux2(c, 1'b0, mux2(d, 1'b0, 1'b1));

endmodule