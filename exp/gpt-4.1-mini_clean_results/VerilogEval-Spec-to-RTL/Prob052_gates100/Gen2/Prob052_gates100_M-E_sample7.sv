module TopModule (
    input  [99:0] in,
    output        out_and,
    output        out_or,
    output        out_xor
);
    // Partial reductions for each group of 10 inputs
    wire [9:0] group_and;
    wire [9:0] group_or;
    wire [9:0] group_xor;

    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin : group_reduction
            // Compute reduction AND of 10 bits in group i
            assign group_and[i] = &in[(i*10)+9 : i*10];
            // Compute reduction OR of 10 bits in group i
            assign group_or[i]  = |in[(i*10)+9 : i*10];
            // Compute reduction XOR of 10 bits in group i
            assign group_xor[i] = ^in[(i*10)+9 : i*10];
        end
    endgenerate

    // Final reduction on the 10 group results to get 100-input reductions
    assign out_and = &group_and; // AND of all group ANDs => 100-input AND
    assign out_or  = |group_or;  // OR of all group ORs => 100-input OR
    assign out_xor = ^group_xor; // XOR of all group XORs => 100-input XOR
endmodule