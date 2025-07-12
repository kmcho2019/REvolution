module TopModule(
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Divide the 100-bit input into 25 groups of 4 bits each
    wire [24:0] and_group;
    wire [24:0] or_group;
    wire [24:0] xor_group;

    genvar i;
    generate
        for (i = 0; i < 25; i = i + 1) begin
            // Perform AND, OR, and XOR operations on each group of 4 bits using reduction operators
            assign and_group[i] = &(in[i*4 +: 4]); // AND reduction
            assign or_group[i] = |(in[i*4 +: 4]);  // OR reduction
            assign xor_group[i] = ^(in[i*4 +: 4]); // XOR reduction
        end
    endgenerate

    // Combine the intermediate results using reduction operators
    assign out_and = &and_group; // AND reduction
    assign out_or = |or_group;  // OR reduction
    assign out_xor = ^xor_group; // XOR reduction

endmodule