module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // mux_in[0] = c OR d
    assign mux_in[0] = c ? 1'b1 : d;

    // mux_in[1] is always 0
    assign mux_in[1] = 1'b0;

    // mux_in[2] = c AND d
    assign mux_in[2] = c ? d : 1'b0;

    // mux_in[3] = c OR ~d
    wire not_d = ~d;
    assign mux_in[3] = c ? 1'b1 : not_d;

endmodule