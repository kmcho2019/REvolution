module TopModule (
    input  [99:0] in,
    output        out_and,
    output        out_or,
    output        out_xor
);

    wire [9:0] and_groups;
    wire [9:0] or_groups;
    wire [9:0] xor_groups;

    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin : group_reduce
            // Each group reduces 10 bits to 1 bit
            assign and_groups[i] = &in[i*10 +: 10];  // reduction AND of bits [i*10 to i*10+9]
            assign or_groups[i]  = |in[i*10 +: 10];  // reduction OR
            assign xor_groups[i] = ^in[i*10 +: 10];  // reduction XOR (parity)
        end
    endgenerate

    // Final outputs reduce the 10 intermediate signals to 1 bit each
    assign out_and = &and_groups;
    assign out_or  = |or_groups;
    assign out_xor = ^xor_groups;

endmodule