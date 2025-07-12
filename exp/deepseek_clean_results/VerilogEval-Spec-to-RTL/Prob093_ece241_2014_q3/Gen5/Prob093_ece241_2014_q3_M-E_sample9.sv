module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // Compute inverted c once
    wire not_c;
    assign not_c = ~c;

    // mux_in[0] = ~(~c & ~d) = c OR d
    assign mux_in[0] = c | d;

    // mux_in[1] is always 0
    assign mux_in[1] = 1'b0;

    // mux_in[2] = c AND d
    assign mux_in[2] = c & d;

    // mux_in[3] = ~(~c & d) = c OR ~d
    assign mux_in[3] = c | ~d;

endmodule