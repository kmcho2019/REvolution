module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // mux_in[0] = ~c | d
    assign mux_in[0] = ~c | d;

    // mux_in[1] is always 0
    assign mux_in[1] = 1'b0;

    // mux_in[2] = c & d
    assign mux_in[2] = c & d;

    // mux_in[3] = (c & d) ? 1'b1 : ~d
    assign mux_in[3] = (c & d) ? 1'b1 : ~d;

endmodule