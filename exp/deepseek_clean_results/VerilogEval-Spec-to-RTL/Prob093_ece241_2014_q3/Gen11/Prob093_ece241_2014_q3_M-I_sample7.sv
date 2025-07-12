module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // mux_in[0] = 0 when cd=00, else 1 (matches K-map)
    assign mux_in[0] = (c | d);

    // mux_in[1] is always 0 (matches K-map)
    assign mux_in[1] = 1'b0;

    // mux_in[2] = 1 when cd=00 or cd=11 (matches K-map)
    assign mux_in[2] = ~(c ^ d);

    // mux_in[3] = 0 only when cd=01 (matches K-map)
    assign mux_in[3] = (c | ~d);

endmodule