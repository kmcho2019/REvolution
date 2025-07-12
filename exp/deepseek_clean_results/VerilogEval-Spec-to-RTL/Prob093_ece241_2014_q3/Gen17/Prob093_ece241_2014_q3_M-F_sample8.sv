module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // ab=00: Output 1 only when cd=10 (c=1,d=0)
    assign mux_in[0] = c & ~d;

    // ab=01: Output 1 only when cd=00 (c=0,d=0)
    assign mux_in[1] = ~c & ~d;

    // ab=11: Output 1 when cd=11 or cd=10 (c=1)
    assign mux_in[2] = c;

    // ab=10: Output 0 only when cd=01 (c=0,d=1)
    assign mux_in[3] = c | ~d;

endmodule