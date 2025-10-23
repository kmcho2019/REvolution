module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);
    // mux_in[0]: corresponds to ab=00 column in K-map: c d: 00->0,01->1,11->1,10->1
    // Let's implement mux_in[0] = f0(c,d)
    // Using d as selector:
    // if d=0: (c=0->0, c=1->1)
    // if d=1: (c=0->1, c=1->1)
    // So mux with d as selector between input0 (c=0?0:1) and input1 (c=0?1:1)
    wire mux_f0_d0; // d=0 input: if c=0 then 0 else 1
    wire mux_f0_d1; // d=1 input: if c=0 then 1 else 1
    // Implement mux_f0_d0: selector c, inputs 0 and 1
    wire zero = 1'b0;
    wire one = 1'b1;
    // mux c selects between zero(0) and one(1)
    // Using 2-to-1 mux: output = c ? one : zero;
    assign mux_f0_d0 = c ? one : zero;
    // mux_f0_d1 = c ? one : one = one
    assign mux_f0_d1 = one;
    // Final mux with d selector
    assign mux_in[0] = d ? mux_f0_d1 : mux_f0_d0;

    // mux_in[1]: ab=01 column: all zeros
    assign mux_in[1] = 1'b0;

    // mux_in[2]: ab=11 column: 00->0, 01->0, 11->1, 10->0
    // Using c as selector:
    // if c=0: d=0->0, d=1->0
    // if c=1: d=0->0, d=1->1
    // So mux with c selector between (d=0->0, d=1->0) and (d=0->0, d=1->1)
    wire mux_f2_c0; // c=0 input: d selects 0 or 0 -> always 0
    wire mux_f2_c1; // c=1 input: d selects 0 or 1

    // mux_f2_c0 = always 0
    assign mux_f2_c0 = zero;
    // mux_f2_c1 = d ? one : zero
    assign mux_f2_c1 = d ? one : zero;
    // Final mux with c selector
    assign mux_in[2] = c ? mux_f2_c1 : mux_f2_c0;

    // mux_in[3]: ab=10 column: 00->1, 01->0, 11->1, 10->1
    // Using d as selector:
    // if d=0: c=0->1, c=1->1
    // if d=1: c=0->0, c=1->1
    // mux with d selector between (c=0->1, c=1->1) and (c=0->0, c=1->1)
    wire mux_f3_d0; // d=0 input: c selects 1 or 1 => always 1
    wire mux_f3_d1; // d=1 input: c selects 0 or 1
    assign mux_f3_d0 = one;
    assign mux_f3_d1 = c ? one : zero;
    assign mux_in[3] = d ? mux_f3_d1 : mux_f3_d0;

endmodule