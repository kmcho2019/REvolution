module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    assign mux_in[0] = ~c | d;               // 0 only when c=1 and d=0 (cd=10)
    assign mux_in[1] = 1'b0;                 // always 0
    assign mux_in[2] = (~c & ~d) | (c & d);  // 1 when cd=00 or 11
    assign mux_in[3] = c | ~d;               // 0 only when c=0 and d=1 (cd=01)

endmodule