module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Parameters for tree structure
    localparam WIDTH = 100;
    localparam LEVELS = $clog2(WIDTH);

    // AND operation with early termination
    wire and_result;
    wire and_done;
    
    parallel_reduction #(
        .WIDTH(WIDTH),
        .OP("AND"),
        .EARLY_TERM(1)
    ) and_reducer (
        .in(in),
        .result(out_and),
        .done()  // Not used in this context
    );

    // OR operation with early termination
    wire or_result;
    wire or_done;
    
    parallel_reduction #(
        .WIDTH(WIDTH),
        .OP("OR"),
        .EARLY_TERM(1)
    ) or_reducer (
        .in(in),
        .result(out_or),
        .done()  // Not used in this context
    );

    // XOR operation (no early termination)
    wire xor_result;
    
    parallel_reduction #(
        .WIDTH(WIDTH),
        .OP("XOR"),
        .EARLY_TERM(0)
    ) xor_reducer (
        .in(in),
        .result(out_xor),
        .done()  // Not used in this context
    );

endmodule

// Parameterized parallel reduction module
module parallel_reduction #(
    parameter WIDTH = 100,
    parameter OP = "AND",  // "AND", "OR", or "XOR"
    parameter EARLY_TERM = 0
) (
    input [WIDTH-1:0] in,
    output result,
    output done
);

    // Calculate required levels for the tree
    localparam LEVELS = $clog2(WIDTH);
    
    // Create a 2D array for intermediate results
    wire [WIDTH-1:0] tree [0:LEVELS];
    
    // Initialize level 0 with input
    assign tree[0] = in;
    
    // Generate tree levels
    genvar level, pos;
    generate
        for (level = 1; level <= LEVELS; level = level + 1) begin : tree_level
            for (pos = 0; pos < (WIDTH >> level); pos = pos + 1) begin : tree_pos
                // Operation selection
                if (OP == "AND") begin
                    assign tree[level][pos] = tree[level-1][2*pos] & tree[level-1][2*pos+1];
                end else if (OP == "OR") begin
                    assign tree[level][pos] = tree[level-1][2*pos] | tree[level-1][2*pos+1];
                end else begin // XOR
                    assign tree[level][pos] = tree[level-1][2*pos] ^ tree[level-1][2*pos+1];
                end
            end
            
            // Handle odd number of inputs at each level
            if ((WIDTH >> (level-1)) % 2) begin : odd_inputs
                assign tree[level][(WIDTH >> level)] = tree[level-1][WIDTH >> (level-1) - 1];
            end
        end
    endgenerate
    
    // Early termination logic for AND/OR
    generate
        if (EARLY_TERM) begin
            // For AND: if any level has a 0, final result is 0
            // For OR: if any level has a 1, final result is 1
            wire early_result;
            wire early_done;
            
            if (OP == "AND") begin
                assign early_done = ~(&in);
                assign early_result = 1'b0;
            end else begin // OR
                assign early_done = |in;
                assign early_result = 1'b1;
            end
            
            assign result = early_done ? early_result : tree[LEVELS][0];
            assign done = early_done;
        end else begin
            assign result = tree[LEVELS][0];
            assign done = 1'b1;
        end
    endgenerate

endmodule