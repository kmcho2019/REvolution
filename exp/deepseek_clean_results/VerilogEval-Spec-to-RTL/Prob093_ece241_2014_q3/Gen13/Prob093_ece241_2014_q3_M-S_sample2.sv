module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // mux_in[0] (ab=00): 1 for cd=00,10 → ~d
    assign mux_in[0] = ~d;

    // mux_in[1] (ab=01): always 0
    assign mux_in[1] = 1'b0;

    // mux_in[2] (ab=11): 1 for cd=00,11 → c XNOR d
    assign mux_in[2] = ~(c ^ d);

    // mux_in[3] (ab=10): 1 for cd=00,11,10 → ~d | (c & d)
    assign mux_in[3] = ~d | (c & d);

endmodule