module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // First level: 25 groups of 4 bits
    wire [24:0] and_l1, or_l1, xor_l1;
    genvar i;
    generate
        for (i = 0; i < 25; i = i + 1) begin : level1
            localparam hi = (i*4)+3;
            localparam lo = i*4;
            assign and_l1[i] = &in[hi:lo];
            assign or_l1[i]  = |in[hi:lo];
            assign xor_l1[i] = ^in[hi:lo];
        end
    endgenerate

    // Second level: 5 groups of 5 bits
    wire [4:0] and_l2, or_l2, xor_l2;
    genvar j;
    generate
        for (j = 0; j < 5; j = j + 1) begin : level2
            localparam hi = (j*5)+4;
            localparam lo = j*5;
            assign and_l2[j] = &and_l1[hi:lo];
            assign or_l2[j]  = |or_l1[hi:lo];
            assign xor_l2[j] = ^xor_l1[hi:lo];
        end
    endgenerate

    // Third level: Combine the 5 intermediate results
    wire and_l3 = &and_l2;
    wire or_l3  = |or_l2;
    wire xor_l3 = ^xor_l2;

    // Final outputs
    assign out_and = and_l3;
    assign out_or  = or_l3;
    assign out_xor = xor_l3;

endmodule