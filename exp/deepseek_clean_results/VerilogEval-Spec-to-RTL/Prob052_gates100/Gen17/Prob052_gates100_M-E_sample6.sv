module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Parameters
    localparam GROUP_SIZE = 10;
    localparam NUM_GROUPS = 10;
    
    // Intermediate group results
    wire [NUM_GROUPS-1:0] group_and;
    wire [NUM_GROUPS-1:0] group_or;
    
    // Compute group results
    generate
        for (genvar g = 0; g < NUM_GROUPS; g = g + 1) begin : group_logic
            localparam HI = (g+1)*GROUP_SIZE - 1;
            localparam LO = g*GROUP_SIZE;
            
            // Group AND (all bits in group must be 1)
            assign group_and[g] = &in[HI:LO];
            
            // Group OR (any bit in group is 1)
            assign group_or[g] = |in[HI:LO];
        end
    endgenerate
    
    // Final outputs
    assign out_and = &group_and;  // All groups must be 1
    assign out_or = |group_or;    // Any group is 1
    assign out_xor = ^in;         // XOR remains optimal as single operation

endmodule