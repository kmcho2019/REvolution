module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // mux_in[0] (ab=00): 1 only when cd=01
    wire mux0_input0 = 1'b0;  // when d=1
    wire mux0_input1 = c;     // when d=0
    assign mux_in[0] = d ? mux0_input0 : mux0_input1;

    // mux_in[1] (ab=01): always 0
    assign mux_in[1] = 1'b0;

    // mux_in[2] (ab=11): 1 when cd=00 or 11
    wire mux2_input0 = ~d;    // when c=0
    wire mux2_input1 = d;     // when c=1
    assign mux_in[2] = c ? mux2_input1 : mux2_input0;

    // mux_in[3] (ab=10): 1 when cd=00,10,11
    wire mux3_input0 = ~d;    // when c=0
    wire mux3_input1 = 1'b1;  // when c=1
    assign mux_in[3] = c ? mux3_input1 : mux3_input0;

endmodule