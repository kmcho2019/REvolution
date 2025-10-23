module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // mux_in[0] (ab=00): 1 only when c=1 and d=0 (cd=10)
    assign mux_in[0] = c & ~d;

    // mux_in[1] (ab=01): always 0
    assign mux_in[1] = 1'b0;

    // mux_in[2] (ab=11): 1 when cd=00 or 11 (c equals d)
    assign mux_in[2] = ~(c ^ d);

    // mux_in[3] (ab=10): 1 when cd=00,11,10 (~d or c)
    assign mux_in[3] = ~d | c;

endmodule