module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Intermediate group results (10 groups)
    wire [9:0] group_and;
    wire [9:0] group_or;
    wire [9:0] group_xor;

    // First level: Reduce 10 inputs per group
    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin : group_reduction
            assign group_and[i] = &in[i*10 +: 10];
            assign group_or[i]  = |in[i*10 +: 10];
            assign group_xor[i] = ^in[i*10 +: 10];
        end
    endgenerate

    // Second level: Reduce 10 group results
    assign out_and = &group_and;
    assign out_or  = |group_or;
    assign out_xor = ^group_xor;

endmodule