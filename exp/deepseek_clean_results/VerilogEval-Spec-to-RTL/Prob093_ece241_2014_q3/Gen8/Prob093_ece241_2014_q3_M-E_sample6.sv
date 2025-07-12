module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // mux_in[0] implementation
    wire mux0_out;
    assign mux0_out = c ? 1'b1 : d;
    assign mux_in[0] = mux0_out;

    // mux_in[1] implementation (constant 0)
    assign mux_in[1] = 1'b0;

    // mux_in[2] implementation
    wire mux2_out;
    assign mux2_out = c ? d : 1'b0;
    assign mux_in[2] = mux2_out;

    // mux_in[3] implementation
    wire mux3_out;
    assign mux3_out = d ? ~c : 1'b1;
    assign mux_in[3] = mux3_out;

endmodule