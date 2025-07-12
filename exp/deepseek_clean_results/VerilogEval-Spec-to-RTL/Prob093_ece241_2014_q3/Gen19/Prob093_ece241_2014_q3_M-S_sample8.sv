module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // mux_in[0] (ab=00): 1 only when cd=10 (c=1,d=0)
    assign mux_in[0] = c ? ~d : 1'b0;

    // mux_in[1] (ab=01): always 0
    assign mux_in[1] = 1'b0;

    // mux_in[2] (ab=11): 1 only when cd=11 (c=1,d=1)
    assign mux_in[2] = c ? d : 1'b0;

    // mux_in[3] (ab=10): 0 only when cd=01 (c=0,d=1)
    assign mux_in[3] = c ? 1'b1 : ~d;

endmodule