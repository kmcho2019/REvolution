module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    wire zero = 1'b0;
    wire one = 1'b1;

    // mux_in[0] = c ? 1 : d
    wire mux0_d0 = d;        // c=0 input
    wire mux0_d1 = one;      // c=1 input
    assign mux_in[0] = c ? mux0_d1 : mux0_d0;

    // mux_in[1] = 0
    assign mux_in[1] = zero;

    // mux_in[2] = c ? d : 0
    wire mux2_c0 = zero;     // c=0 input
    wire mux2_c1 = d;        // c=1 input
    assign mux_in[2] = c ? mux2_c1 : mux2_c0;

    // mux_in[3] = d ? c : 1
    wire mux3_d0 = one;      // d=0 input
    wire mux3_d1 = c;        // d=1 input
    assign mux_in[3] = d ? mux3_d1 : mux3_d0;

endmodule