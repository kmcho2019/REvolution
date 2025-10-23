module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // First level reduction: 10 groups of 10 bits
    wire [9:0] and_groups, or_groups, xor_groups;
    
    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin : GROUP_REDUCTION
            // Instantiate reduction modules for each group
            ReductionUnit #(.WIDTH(10)) ru (
                .in(in[i*10 +: 10]),
                .out_and(and_groups[i]),
                .out_or(or_groups[i]),
                .out_xor(xor_groups[i])
            );
        end
    endgenerate

    // Second level reduction: combine group results
    ReductionUnit #(.WIDTH(10)) final_reduction (
        .in_and(and_groups),
        .in_or(or_groups),
        .in_xor(xor_groups),
        .out_and(out_and),
        .out_or(out_or),
        .out_xor(out_xor)
    );

endmodule

// Parameterized reduction unit module
module ReductionUnit #(
    parameter WIDTH = 10
) (
    input [WIDTH-1:0] in,
    input [WIDTH-1:0] in_and,  // Only used in final reduction
    input [WIDTH-1:0] in_or,    // Only used in final reduction
    input [WIDTH-1:0] in_xor,   // Only used in final reduction
    output out_and,
    output out_or,
    output out_xor
);

    // Use conditional generation for different levels
    generate
        if (WIDTH == 10) begin : FIRST_LEVEL
            assign out_and = &in;
            assign out_or = |in;
            assign out_xor = ^in;
        end
        else begin : FINAL_LEVEL
            assign out_and = &in_and;
            assign out_or = |in_or;
            assign out_xor = ^in_xor;
        end
    endgenerate

endmodule