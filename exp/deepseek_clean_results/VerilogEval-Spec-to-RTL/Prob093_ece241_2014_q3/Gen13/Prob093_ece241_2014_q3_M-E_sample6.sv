module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // Internal wires for mux outputs
    wire mux0_stage1, mux2_stage1, mux3_stage1;

    // ab=00 implementation (column 00)
    assign mux0_stage1 = d ? 1'b1 : 1'b0;  // First stage mux (d selects)
    assign mux_in[0] = c ? 1'b1 : mux0_stage1;  // Second stage mux (c selects)

    // ab=01 implementation (column 01)
    assign mux_in[1] = 1'b0;  // Always 0

    // ab=11 implementation (column 11)
    assign mux2_stage1 = d ? c : 1'b1;  // d selects between c and 1
    assign mux_in[2] = mux2_stage1;

    // ab=10 implementation (column 10)
    assign mux3_stage1 = d ? 1'b0 : 1'b1;  // First stage mux (d selects)
    assign mux_in[3] = c ? 1'b1 : mux3_stage1;  // Second stage mux (c selects)

endmodule