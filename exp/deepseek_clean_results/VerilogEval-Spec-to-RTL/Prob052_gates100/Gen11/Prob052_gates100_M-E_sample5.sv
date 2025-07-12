module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // First level: Process 10 groups of 10 bits in parallel
    wire [9:0] group_and;
    wire [9:0] group_or;
    wire [9:0] group_xor;
    
    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin : GROUP_LOGIC
            // AND reduction of each 10-bit group
            assign group_and[i] = &in[i*10 +: 10];
            // OR reduction of each 10-bit group
            assign group_or[i] = |in[i*10 +: 10];
            // XOR reduction of each 10-bit group
            assign group_xor[i] = ^in[i*10 +: 10];
        end
    endgenerate

    // Second level: Combine the 10 group results
    assign out_and = &group_and;  // AND of all group AND results
    assign out_or = |group_or;    // OR of all group OR results
    assign out_xor = ^group_xor;  // XOR of all group XOR results

endmodule