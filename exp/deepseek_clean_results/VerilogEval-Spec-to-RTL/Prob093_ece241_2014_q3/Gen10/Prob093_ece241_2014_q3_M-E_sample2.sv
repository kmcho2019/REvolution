module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // mux_in[0] for ab=00: 0 when cd=00, else 1
    wire mux0_sel = c | d;
    assign mux_in[0] = mux0_sel ? 1'b1 : 1'b0;

    // mux_in[1] for ab=01: always 0
    assign mux_in[1] = 1'b0;

    // mux_in[2] for ab=11: output c
    assign mux_in[2] = c;

    // mux_in[3] for ab=10: ~d when c=0, else 1
    assign mux_in[3] = c ? 1'b1 : ~d;

endmodule