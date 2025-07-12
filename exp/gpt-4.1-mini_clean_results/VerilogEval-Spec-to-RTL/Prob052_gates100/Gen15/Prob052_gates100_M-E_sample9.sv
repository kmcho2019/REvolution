module TopModule (
    input  [99:0] in,
    output        out_and,  // 100-input AND
    output        out_or,   // 100-input OR
    output        out_xor   // 100-input XOR (parity)
);

    // Intermediate signals for each group's reductions (10 groups)
    wire [9:0] group_and;
    wire [9:0] group_or;
    wire [9:0] group_xor;

    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin : groups
            // Extract each 10-bit group
            wire [9:0] group_bits = in[i*10 +: 10];

            // Local reductions for each group
            assign group_and[i] = &group_bits;
            assign group_or[i]  = |group_bits;
            assign group_xor[i] = ^group_bits;
        end
    endgenerate

    // Final outputs are reductions over the 10 intermediate group signals
    assign out_and = &group_and;
    assign out_or  = |group_or;
    assign out_xor = ^group_xor;

endmodule