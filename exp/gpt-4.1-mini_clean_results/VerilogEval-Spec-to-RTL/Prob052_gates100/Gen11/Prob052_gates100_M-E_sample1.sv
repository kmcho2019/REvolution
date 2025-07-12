module TopModule (
    input  [99:0] in,
    output        out_and,
    output        out_or,
    output        out_xor
);

    // Intermediate wires for partial reductions on groups of 10 bits
    wire [9:0] and_parts;
    wire [9:0] or_parts;
    wire [9:0] xor_parts;

    genvar i, j;
    generate
        // For each group of 10 bits, reduce locally
        for (i = 0; i < 10; i = i + 1) begin : group_reduce
            wire [9:0] group_bits;
            for (j = 0; j < 10; j = j + 1) begin : group_bits_assign
                assign group_bits[j] = in[i*10 + j];
            end
            assign and_parts[i] = &group_bits; // AND of 10 bits
            assign or_parts[i]  = |group_bits; // OR of 10 bits
            assign xor_parts[i] = ^group_bits; // XOR of 10 bits
        end
    endgenerate

    // Final reduction combining the 10 intermediate results
    assign out_and = &and_parts; // AND of the 10 partial ANDs
    assign out_or  = |or_parts;  // OR of the 10 partial ORs
    assign out_xor = ^xor_parts; // XOR of the 10 partial XORs

endmodule