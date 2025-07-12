module TopModule(
    input  [99:0] in,
    output        out_and,
    output        out_or,
    output        out_xor
);

    wire [9:0] group_and;
    wire [9:0] group_or;
    wire [9:0] group_xor;

    // Compute partial reductions on 10-bit groups
    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin : group_reductions
            assign group_and[i] = &in[(i*10) +: 10];
            assign group_or[i]  = |in[(i*10) +: 10];
            assign group_xor[i] = ^in[(i*10) +: 10];
        end
    endgenerate

    // Combine partial results for final outputs
    assign out_and = &group_and;
    assign out_or  = |group_or;
    assign out_xor = ^group_xor;

endmodule