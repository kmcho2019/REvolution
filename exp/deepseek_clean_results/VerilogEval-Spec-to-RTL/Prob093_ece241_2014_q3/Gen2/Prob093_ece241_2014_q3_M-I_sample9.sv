module TopModule (
    input c,
    input d,
    output [3:0] mux_in
);

    wire not_d;
    wire mux0_out;
    wire mux2_out;
    wire mux3_out;

    // mux_in[0]: ~(c & ~d)
    assign not_d = d ? 1'b0 : 1'b1;
    assign mux0_out = c ? not_d : 1'b1;

    // mux_in[1]: constant 0
    assign mux_in[1] = 1'b0;

    // mux_in[2]: c & d
    assign mux2_out = c ? d : 1'b0;

    // mux_in[3]: ~d | c
    assign mux3_out = c ? 1'b1 : not_d;

    assign mux_in[0] = mux0_out;
    assign mux_in[2] = mux2_out;
    assign mux_in[3] = mux3_out;

endmodule