module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // mux_in[0] = ~c OR d
    wire not_c = ~c;
    assign mux_in[0] = not_c ? 1'b1 : d;

    // mux_in[1] is always 0
    assign mux_in[1] = 1'b0;

    // mux_in[2] = c AND d
    assign mux_in[2] = c ? d : 1'b0;

    // mux_in[3] = ~d OR c
    wire not_d = ~d;
    assign mux_in[3] = not_d ? 1'b1 : c;

endmodule