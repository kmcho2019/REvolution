module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // mux_in[0] = 1 when cd=01,11,10 → ~(c & ~d)
    assign mux_in[0] = ~(c & ~d);

    // mux_in[1] is always 0
    assign mux_in[1] = 1'b0;

    // mux_in[2] = 1 only when cd=11 → c & d
    assign mux_in[2] = c & d;

    // mux_in[3] = 1 when cd=00,11,10 → ~d | (c & d)
    // Implemented as: if c=1 then d else ~d
    assign mux_in[3] = c ? d : ~d;

endmodule