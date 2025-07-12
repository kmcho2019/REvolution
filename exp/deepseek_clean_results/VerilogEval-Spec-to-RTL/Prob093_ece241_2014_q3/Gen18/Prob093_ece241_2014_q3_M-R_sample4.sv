module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);
    // mux_in[0] for ab=00: output 1 when c=1 OR d=1 (cd=01,11,10)
    wire mux0_sel = c;
    wire mux0_in0 = d;
    wire mux0_in1 = 1'b1;
    assign mux_in[0] = mux0_sel ? mux0_in1 : mux0_in0;

    // mux_in[1] for ab=01: always 0
    assign mux_in[1] = 1'b0;

    // mux_in[2] for ab=11: output c when d=1 (cd=11)
    wire mux2_sel = d;
    wire mux2_in0 = 1'b0;
    wire mux2_in1 = c;
    assign mux_in[2] = mux2_sel ? mux2_in1 : mux2_in0;

    // mux_in[3] for ab=10: output 0 only when cd=01 (c=0,d=1)
    wire mux3_sel = d;
    wire mux3_in0 = 1'b1;
    wire mux3_in1 = c;
    assign mux_in[3] = mux3_sel ? mux3_in1 : mux3_in0;

endmodule