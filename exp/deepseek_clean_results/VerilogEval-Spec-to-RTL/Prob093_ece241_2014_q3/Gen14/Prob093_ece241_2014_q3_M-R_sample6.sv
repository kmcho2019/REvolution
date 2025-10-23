module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // ab=00: 0 when cd=00, 1 otherwise → c OR d
    assign mux_in[0] = c | d;

    // ab=01: 1 only when cd=01 → ~c AND d
    assign mux_in[1] = ~c & d;

    // ab=11: 1 when c=1 (regardless of d)
    assign mux_in[2] = c;

    // ab=10: 0 only when cd=01 → NOT (~c AND d)
    assign mux_in[3] = ~(~c & d);

endmodule