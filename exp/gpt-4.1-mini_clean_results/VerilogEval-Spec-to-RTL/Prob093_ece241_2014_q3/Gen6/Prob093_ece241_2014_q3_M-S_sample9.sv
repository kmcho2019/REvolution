module TopModule (
    input  c,
    input  d,
    output [3:0] mux_in
);
    // Implement NOT d using a 2-to-1 mux: not_d = d ? 0 : 1
    wire not_d = d ? 1'b0 : 1'b1;

    // mux_in[0] = c OR d = mux(c, 1, d)
    wire f0 = c ? 1'b1 : d;

    // mux_in[1] = 0
    wire f1 = 1'b0;

    // mux_in[2] = c AND d = mux(c, d, 0)
    wire f2 = c ? d : 1'b0;

    // mux_in[3] = c OR (NOT d) = mux(c, 1, not_d)
    wire f3 = c ? 1'b1 : not_d;

    assign mux_in = {f3, f2, f1, f0};
endmodule