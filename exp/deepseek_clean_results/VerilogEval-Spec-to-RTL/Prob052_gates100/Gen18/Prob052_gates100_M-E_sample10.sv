module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Parameters for the reduction tree
    localparam WIDTH = 100;
    localparam LEVELS = $clog2(WIDTH);
    
    // Reduction tree wires
    wire [WIDTH-1:0] and_tree [0:LEVELS];
    wire [WIDTH-1:0] or_tree  [0:LEVELS];
    wire [WIDTH-1:0] xor_tree [0:LEVELS];
    
    // Initialize level 0 with input
    assign and_tree[0] = in;
    assign or_tree[0]  = in;
    assign xor_tree[0] = in;
    
    // Generate reduction levels
    genvar i, j;
    generate
        for (i = 1; i <= LEVELS; i = i + 1) begin : reduction_level
            for (j = 0; j < (WIDTH + (1 << (i-1)) - 1) / (1 << i); j = j + 1) begin : tree_node
                // Calculate the actual number of inputs for this node
                localparam INPUTS = (j == ((WIDTH + (1 << (i-1)) - 1) / (1 << i) - 1) ? 
                                    (WIDTH - (1 << i) * j) : (1 << i);
                
                // Create the reduction nodes
                if (INPUTS == 1) begin
                    assign and_tree[i][j] = and_tree[i-1][j];
                    assign or_tree[i][j]  = or_tree[i-1][j];
                    assign xor_tree[i][j] = xor_tree[i-1][j];
                end
                else begin
                    assign and_tree[i][j] = &and_tree[i-1][j*(1 << i) +: INPUTS];
                    assign or_tree[i][j]  = |or_tree[i-1][j*(1 << i) +: INPUTS];
                    assign xor_tree[i][j] = ^xor_tree[i-1][j*(1 << i) +: INPUTS];
                end
            end
        end
    endgenerate
    
    // Final outputs are the root of the trees
    assign out_and = and_tree[LEVELS][0];
    assign out_or  = or_tree[LEVELS][0];
    assign out_xor = xor_tree[LEVELS][0];

endmodule