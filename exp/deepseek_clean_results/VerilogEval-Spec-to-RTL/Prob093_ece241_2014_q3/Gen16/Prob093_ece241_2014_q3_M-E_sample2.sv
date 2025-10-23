module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // mux_in[0] for ab=00: 0 when cd=00, 1 otherwise
    assign mux_in[0] = c ? 1'b1 : d;

    // mux_in[1] for ab=01: always 0
    assign mux_in[1] = 1'b0;

    // mux_in[2] for ab=11: c AND d
    assign mux_in[2] = d ? c : 1'b0;

    // mux_in[3] for ab=10: 1 except when cd=01
    assign mux_in[3] = d ? ~c : 1'b1;

endmodule