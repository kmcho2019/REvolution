module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Parameters for hierarchical reduction
    localparam GROUP_SIZE = 4;
    localparam NUM_GROUPS = 25;

    // Intermediate results for AND/OR
    wire [NUM_GROUPS-1:0] group_and;
    wire [NUM_GROUPS-1:0] group_or;

    // Generate parallel 4-bit reduction groups
    genvar i;
    generate
        for (i = 0; i < NUM_GROUPS; i = i + 1) begin : group_reduction
            localparam HI = (i+1)*GROUP_SIZE - 1;
            localparam LO = i*GROUP_SIZE;
            
            if (HI < 100) begin
                assign group_and[i] = &in[HI:LO];
                assign group_or[i]  = |in[HI:LO];
            end else begin // Handle last partial group
                assign group_and[i] = &in[99:LO];
                assign group_or[i]  = |in[99:LO];
            end
        end
    endgenerate

    // Final reduction tree for AND/OR
    assign out_and = &group_and;
    assign out_or  = |group_or;

    // Skip-chain XOR implementation
    wire [NUM_GROUPS:0] xor_chain;
    assign xor_chain[0] = 1'b0;
    
    generate
        for (i = 0; i < NUM_GROUPS; i = i + 1) begin : xor_chain_gen
            localparam HI = (i+1)*GROUP_SIZE - 1;
            localparam LO = i*GROUP_SIZE;
            
            if (HI < 100) begin
                assign xor_chain[i+1] = xor_chain[i] ^ (^in[HI:LO]);
            end else begin
                assign xor_chain[i+1] = xor_chain[i] ^ (^in[99:LO]);
            end
        end
    endgenerate
    
    assign out_xor = xor_chain[NUM_GROUPS];

endmodule