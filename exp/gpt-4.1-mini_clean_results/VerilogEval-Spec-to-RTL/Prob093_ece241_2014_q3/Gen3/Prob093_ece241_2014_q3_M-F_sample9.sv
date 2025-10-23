module TopModule (
    input  c,
    input  d,
    output [3:0] mux_in
);
    // 2-to-1 mux helper: mux(sel, in0, in1) = sel ? in1 : in0
    // Used as function to clarify but instantiated inline below

    // Implement NOT d using mux:
    // NOT d = mux(d, 1'b0, 1'b1)
    wire not_d = d ? 1'b0 : 1'b1;

    // Implement f0 = c OR d = mux(c, 1, d)
    wire f0 = c ? 1'b1 : d;

    // Implement f1 = 0 (constant zero)
    wire f1 = 1'b0;

    // Implement f2 = c AND d = mux(c, d, 1'b0)
    wire f2 = c ? d : 1'b0;

    // Implement f3 = c OR (NOT d) = mux(c, 1, not_d)
    wire f3 = c ? 1'b1 : not_d;

    // Assign mux_in bits: index corresponds to ab selector inputs of 4-to-1 mux
    // mux_in[0] = f0 (ab=00)
    // mux_in[1] = f1 (ab=01)
    // mux_in[2] = f2 (ab=11)
    // mux_in[3] = f3 (ab=10)
    assign mux_in = {f3, f2, f1, f0};
endmodule