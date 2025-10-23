module TopModule (
    input  c,
    input  d,
    output [3:0] mux_in
);
    // 2-to-1 mux helper via conditional operator: mux(sel, in0, in1) = sel ? in1 : in0

    // NOT d = mux(d, 1'b0, 1'b1)
    wire not_d = d ? 1'b0 : 1'b1;

    // f0 = c OR d = mux(c, 1'b1, d)
    wire f0 = c ? 1'b1 : d;

    // f1 = 0 constant
    wire f1 = 1'b0;

    // f2 = c AND d = mux(c, d, 1'b0)
    wire f2 = c ? d : 1'b0;

    // f3 = c OR (NOT d) = mux(c, 1'b1, not_d)
    wire f3 = c ? 1'b1 : not_d;

    // Assign mux_in bits according to ab selector indexing:
    // mux_in[0] for ab=00
    // mux_in[1] for ab=01
    // mux_in[2] for ab=11
    // mux_in[3] for ab=10
    assign mux_in = {f3, f2, f1, f0};
endmodule