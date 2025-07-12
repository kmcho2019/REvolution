module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // mux_in[0] (ab=00): matches d (0,1,1,0 for cd=00,01,11,10)
    assign mux_in[0] = d;

    // mux_in[1] (ab=01): always 0
    assign mux_in[1] = 1'b0;

    // mux_in[2] (ab=11): 1 only when cd=11 (c AND d)
    assign mux_in[2] = c & d;

    // mux_in[3] (ab=10): 1 when cd=00,10,11 (d OR ~c)
    assign mux_in[3] = d | ~c;

endmodule