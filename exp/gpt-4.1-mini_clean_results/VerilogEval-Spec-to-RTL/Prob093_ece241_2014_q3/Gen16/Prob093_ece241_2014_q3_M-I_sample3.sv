module TopModule (
    input  c,
    input  d,
    output [3:0] mux_in
);
    // mux_in[0] for ab=00:
    // From K-map cd=00:0, 01:1, 11:1, 10:1
    // Implemented as: if d=1 output 1 else output c
    assign mux_in[0] = d ? 1'b1 : c;

    // mux_in[1] for ab=01: all zeros
    assign mux_in[1] = 1'b0;

    // mux_in[2] for ab=11: 1 only when c=1 and d=1
    // Implemented as: if c=1 output d else 0
    assign mux_in[2] = c ? d : 1'b0;

    // mux_in[3] for ab=10: output 0 only at cd=01 (c=0,d=1)
    // Implemented as: if d=1 output c else 1
    assign mux_in[3] = d ? c : 1'b1;

endmodule