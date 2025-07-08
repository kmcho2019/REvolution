module top_module (
    input c,
    input d,
    output [3:0] mux_in
);

    // 2-to-1 mux function
    // mux(selector, in0, in1) = selector ? in1 : in0
    // We'll implement it with assign statements.

    wire not_d;

    // not_d = ~d = mux(d,0,1)
    assign not_d = d ? 1'b0 : 1'b1;

    // mux_in[0] = c + d = mux(c, d, 1) = selector c: if c=0 output d else 1
    // But original thought: mux(c,1,d) - corrected here for mux(selector,in0,in1)
    // selector c: if c=0 output in0 else in1
    // So for mux_in[0] = c + d = if c=0 output d else 1
    assign mux_in[0] = c ? 1'b1 : d;

    // mux_in[1] = 0
    assign mux_in[1] = 1'b0;

    // mux_in[2] = c & d = mux(c,0,d)
    // selector c: if c=0 output 0 else d
    assign mux_in[2] = c ? d : 1'b0;

    // mux_in[3] = c + ~d = mux(c, not_d, 1)
    // But selector c: if c=0 output in0 else in1
    // For c+~d = if c=0 output ~d else 1
    assign mux_in[3] = c ? 1'b1 : not_d;

endmodule