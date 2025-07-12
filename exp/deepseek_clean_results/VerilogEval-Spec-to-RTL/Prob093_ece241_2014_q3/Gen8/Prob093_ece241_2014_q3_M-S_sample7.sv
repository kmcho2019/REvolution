module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);
    // mux_in[0] = c ? d : 1'b1
    wire mux0_sel = c;
    wire mux0_in0 = 1'b1;
    wire mux0_in1 = d;
    assign mux_in[0] = mux0_sel ? mux0_in1 : mux0_in0;

    // mux_in[1] = constant 0
    assign mux_in[1] = 1'b0;

    // mux_in[2] = c ? d : 1'b0
    wire mux2_sel = c;
    wire mux2_in0 = 1'b0;
    wire mux2_in1 = d;
    assign mux_in[2] = mux2_sel ? mux2_in1 : mux2_in0;

    // mux_in[3] = c ? 1'b1 : ~d
    wire mux3_sel = c;
    wire mux3_in0 = ~d;
    wire mux3_in1 = 1'b1;
    assign mux_in[3] = mux3_sel ? mux3_in1 : mux3_in0;

endmodule