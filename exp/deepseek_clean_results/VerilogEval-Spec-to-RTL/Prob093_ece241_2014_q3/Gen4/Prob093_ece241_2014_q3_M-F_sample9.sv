module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // Compute ~c & ~d for mux_in[0]
    wire not_c_and_not_d;
    assign not_c_and_not_d = ~c & ~d;

    // Compute ~c & d for mux_in[3]
    wire not_c_and_d;
    assign not_c_and_d = ~c & d;

    // mux_in[0] = ~(~c & ~d)
    assign mux_in[0] = ~not_c_and_not_d;

    // mux_in[1] is always 0
    assign mux_in[1] = 1'b0;

    // mux_in[2] = c & d
    assign mux_in[2] = c & d;

    // mux_in[3] = ~(~c & d)
    assign mux_in[3] = ~not_c_and_d;

endmodule