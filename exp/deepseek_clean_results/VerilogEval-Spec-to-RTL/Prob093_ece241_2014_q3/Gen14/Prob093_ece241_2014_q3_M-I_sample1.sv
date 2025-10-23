module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    assign mux_in[0] = d;                     // 1 when cd=01 or 11 (d=1)
    assign mux_in[1] = 1'b0;                  // always 0
    assign mux_in[2] = (~c & ~d) | (c & d);   // 1 when cd=00 or 11
    assign mux_in[3] = c | ~d;                // 0 only when cd=01 (c=0 and d=1)

endmodule