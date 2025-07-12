module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);
    // mux_in[0] for ab=00: OR function (0 for cd=00, 1 otherwise)
    assign mux_in[0] = c | d;

    // mux_in[1] for ab=01: always 0
    assign mux_in[1] = 1'b0;

    // mux_in[2] for ab=11: XNOR function (1 when c equals d)
    assign mux_in[2] = ~(c ^ d);

    // mux_in[3] for ab=10: 0 only when cd=01 (c=0 and d=1)
    assign mux_in[3] = c | ~d;

endmodule