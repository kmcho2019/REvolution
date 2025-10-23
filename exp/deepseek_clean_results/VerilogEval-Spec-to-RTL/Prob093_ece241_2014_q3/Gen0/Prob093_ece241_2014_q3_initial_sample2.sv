module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // mux_in[0] = d OR c = mux(d, 1, c)
    wire mux0_out;
    assign mux0_out = c ? 1'b1 : d;

    // mux_in[1] = 0
    assign mux_in[1] = 1'b0;

    // mux_in[2] = c AND d = mux(0, d, c)
    wire mux2_out;
    assign mux2_out = c ? d : 1'b0;

    // mux_in[3] = NOT d = mux(1, 0, d)
    wire mux3_out;
    assign mux3_out = d ? 1'b0 : 1'b1;

    assign mux_in = {mux3_out, mux2_out, 1'b0, mux0_out};

endmodule