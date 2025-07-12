module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // mux_in[0] (ab=00): always 1
    assign mux_in[0] = 1'b1;

    // mux_in[1] (ab=01): always 0
    assign mux_in[1] = 1'b0;

    // mux_in[2] (ab=11): 1 when c == d (XNOR)
    assign mux_in[2] = c ? d : ~d;

    // mux_in[3] (ab=10): 0 only when c=0 and d=1
    assign mux_in[3] = c ? 1'b1 : ~d;

endmodule