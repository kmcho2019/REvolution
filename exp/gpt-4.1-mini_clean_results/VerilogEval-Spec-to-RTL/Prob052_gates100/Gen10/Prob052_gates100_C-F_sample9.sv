module TopModule (
    input  [99:0] in,
    output        out_and,
    output        out_or,
    output        out_xor
);

    // First level reduction: 10 groups of 10 bits each
    wire [9:0] group_and;
    wire [9:0] group_or;
    wire [9:0] group_xor;

    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin : group_reduce
            assign group_and[i] = &in[i*10 +: 10];
            assign group_or[i]  = |in[i*10 +: 10];
            assign group_xor[i] = ^in[i*10 +: 10];
        end
    endgenerate

    // Final reduction over the 10 group results
    assign out_and = &group_and;
    assign out_or  = |group_or;
    assign out_xor = ^group_xor;

endmodule