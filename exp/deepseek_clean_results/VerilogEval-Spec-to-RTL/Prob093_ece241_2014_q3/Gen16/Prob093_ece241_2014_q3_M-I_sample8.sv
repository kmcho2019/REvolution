module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // ab=00: Output matches OR of inputs (0 only when both are 0)
    assign mux_in[0] = c | d;

    // ab=01: Output 1 only when c=0 and d=1
    assign mux_in[1] = ~c & d;

    // ab=11: Output matches c (0 when c=0, 1 when c=1)
    assign mux_in[2] = c;

    // ab=10: Output 0 only when c=0 and d=1, else 1
    assign mux_in[3] = c | ~d;

endmodule