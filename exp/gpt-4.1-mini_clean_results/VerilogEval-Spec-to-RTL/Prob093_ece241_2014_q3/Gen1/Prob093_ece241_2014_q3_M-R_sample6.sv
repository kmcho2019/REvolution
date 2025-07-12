module TopModule(
    input wire c,
    input wire d,
    output wire [3:0] mux_in
);

    wire zero = 1'b0;
    wire one  = 1'b1;

    // mux_in[0]: ab=00 column: c d => value
    // 00->0, 01->1, 11->1, 10->1
    // Let's choose c as selector first (or d), verify both:
    // Using d as selector:
    // d=0: c=0->0, c=1->1
    // d=1: c=0->1, c=1->1
    // So first level mux with d select:
    //  if d=0 then (c ? 1 : 0)
    //  else (c ? 1 : 1) => always 1
    wire mux0_lower = c ? one : zero;
    wire mux0_upper = one;
    assign mux_in[0] = d ? mux0_upper : mux0_lower;

    // mux_in[1]: ab=01 column: all zeros
    assign mux_in[1] = zero;

    // mux_in[2]: ab=11 column: 00->0, 01->0, 11->1, 10->0
    // Use c as selector:
    // c=0: d=0->0, d=1->0 => 0 always
    // c=1: d=0->0, d=1->1
    wire mux2_lower = zero;
    wire mux2_upper = d ? one : zero;
    assign mux_in[2] = c ? mux2_upper : mux2_lower;

    // mux_in[3]: ab=10 column: 00->1, 01->0, 11->1, 10->1
    // Try d as selector:
    // d=0: c=0->1, c=1->1 => 1 always
    // d=1: c=0->0, c=1->1
    wire mux3_lower = one;
    wire mux3_upper = c ? one : zero;
    assign mux_in[3] = d ? mux3_upper : mux3_lower;

endmodule