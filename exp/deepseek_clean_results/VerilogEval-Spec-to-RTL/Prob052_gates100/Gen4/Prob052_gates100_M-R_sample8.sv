module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Level 1: Process 25 groups of 4 bits each
    wire [24:0] and_l1, or_l1, xor_l1;
    genvar i;
    generate
        for (i = 0; i < 25; i = i + 1) begin : LEVEL1
            localparam hi = (i == 24) ? 99 : (i*4 + 3);
            assign and_l1[i] = &in[i*4 +: (hi-i*4+1)];
            assign or_l1[i]  = |in[i*4 +: (hi-i*4+1)];
            assign xor_l1[i] = ^in[i*4 +: (hi-i*4+1)];
        end
    endgenerate

    // Level 2: Process 7 groups of ~4 bits (from 25 inputs)
    wire [6:0] and_l2, or_l2, xor_l2;
    genvar j;
    generate
        for (j = 0; j < 7; j = j + 1) begin : LEVEL2
            localparam lo = j*4;
            localparam hi = (j == 6) ? 24 : (j*4 + 3);
            assign and_l2[j] = &and_l1[lo +: (hi-lo+1)];
            assign or_l2[j]  = |or_l1[lo +: (hi-lo+1)];
            assign xor_l2[j] = ^xor_l1[lo +: (hi-lo+1)];
        end
    endgenerate

    // Level 3: Final reduction (7 inputs to 1)
    assign out_and = &and_l2;
    assign out_or  = |or_l2;
    assign out_xor = ^xor_l2;

endmodule