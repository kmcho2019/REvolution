module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // mux_in[0] for ab=00
    wire mux0_stage1;
    assign mux0_stage1 = d ? 1'b1 : 1'b0;  // When c=1, select between d and 1
    assign mux_in[0] = c ? mux0_stage1 : d; // First level mux with c as selector

    // mux_in[1] for ab=01 - always 0
    assign mux_in[1] = 1'b0;

    // mux_in[2] for ab=11 - simple AND
    assign mux_in[2] = c & d;

    // mux_in[3] for ab=10
    wire mux3_stage1;
    assign mux3_stage1 = d ? c : 1'b1;     // When d=1, select between 0 and c
    assign mux_in[3] = d ? 1'b0 : 1'b1;    // First level mux with d as selector

endmodule