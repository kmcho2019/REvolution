module TopModule(
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Group the 100 inputs into 25 groups of 4 inputs each
    wire [24:0] and_group_results;
    wire [24:0] or_group_results;
    wire [24:0] xor_group_results;

    // Perform AND, OR, and XOR operations within each group
    genvar i;
    generate
        for (i = 0; i < 25; i = i + 1) begin
            assign and_group_results[i] = &(in[(i*4)+:4]);
            assign or_group_results[i] = |(in[(i*4)+:4]);
            assign xor_group_results[i] = ^(in[(i*4)+:4]);
        end
    endgenerate

    // Combine group results to obtain final outputs
    assign out_and = &(and_group_results);
    assign out_or = |(or_group_results);
    assign out_xor = ^(xor_group_results);

endmodule