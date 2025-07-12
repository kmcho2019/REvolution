module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // Shared computation: c & d
    wire c_and_d;
    assign c_and_d = c & d;

    // Compute ~d for mux_in[3]
    wire not_d;
    assign not_d = ~d;

    // mux_in[0] = ~(c & ~d) = c ? 1 : d
    assign mux_in[0] = c ? 1'b1 : d;

    // mux_in[1] is always 0
    assign mux_in[1] = 1'b0;

    // mux_in[2] = c & d
    assign mux_in[2] = c_and_d;

    // mux_in[3] = ~d | (c & d)
    assign mux_in[3] = not_d | c_and_d;

endmodule