module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // mux_in[0] (ab=00): 1 when cd=10 or cd=01 or cd=11 (c OR ~d)
    assign mux_in[0] = c ? 1'b1 : ~d;

    // mux_in[1] (ab=01): always 0
    assign mux_in[1] = 1'b0;

    // mux_in[2] (ab=11): 0 only when cd=01 (c=0,d=1)
    assign mux_in[2] = c ? 1'b1 : ~d;

    // mux_in[3] (ab=10): same as mux_in[2]
    assign mux_in[3] = c ? 1'b1 : ~d;

endmodule