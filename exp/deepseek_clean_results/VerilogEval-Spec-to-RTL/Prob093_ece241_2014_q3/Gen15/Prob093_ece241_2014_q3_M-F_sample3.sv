module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    assign mux_in[0] = d | ~c;               // 1 for cd=01,11,10
    assign mux_in[1] = 1'b0;                 // always 0
    assign mux_in[2] = c & d;                // 1 only for cd=11
    assign mux_in[3] = (~c & ~d) | (c & d);  // 1 for cd=00,11

endmodule