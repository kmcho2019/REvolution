module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // mux_in[0] for ab=00: 1 only when cd=10 (c=1,d=0)
    wire mux0_stage1;
    assign mux0_stage1 = d ? 1'b0 : 1'b0;  // First stage: 0 when d=1
    assign mux_in[0] = c ? (d ? 1'b0 : 1'b1) : mux0_stage1;

    // mux_in[1] for ab=01: always 0
    assign mux_in[1] = 1'b0;

    // mux_in[2] for ab=11: 1 only when cd=11 (c=1,d=1)
    assign mux_in[2] = c & d;

    // mux_in[3] for ab=10: 0 only when cd=01 (c=0,d=1)
    assign mux_in[3] = d ? (c ? 1'b1 : 1'b0) : 1'b1;

endmodule