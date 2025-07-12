module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Tree reduction parameters
    localparam WIDTH = 100;
    localparam GROUP_SIZE = 2;
    
    // Function to calculate required tree levels
    function integer calc_levels;
        input integer width;
        integer temp;
        begin
            temp = 0;
            while (width > 1) begin
                width = (width + GROUP_SIZE - 1) / GROUP_SIZE;
                temp = temp + 1;
            end
            calc_levels = temp;
        end
    endfunction
    
    localparam LEVELS = calc_levels(WIDTH);
    
    // Generate tree structure for each operation
    generate
        // AND tree
        wire [LEVELS:0][WIDTH-1:0] and_tree;
        assign and_tree[0] = in;
        for (genvar lvl = 0; lvl < LEVELS; lvl = lvl + 1) begin : and_gen
            for (genvar i = 0; i < ((WIDTH-1) >> (lvl+1)) + 1; i = i + 1) begin
                assign and_tree[lvl+1][i] = &and_tree[lvl][i*GROUP_SIZE +: GROUP_SIZE];
            end
        end
        assign out_and = and_tree[LEVELS][0];
        
        // OR tree
        wire [LEVELS:0][WIDTH-1:0] or_tree;
        assign or_tree[0] = in;
        for (genvar lvl = 0; lvl < LEVELS; lvl = lvl + 1) begin : or_gen
            for (genvar i = 0; i < ((WIDTH-1) >> (lvl+1)) + 1; i = i + 1) begin
                assign or_tree[lvl+1][i] = |or_tree[lvl][i*GROUP_SIZE +: GROUP_SIZE];
            end
        end
        assign out_or = or_tree[LEVELS][0];
        
        // XOR tree
        wire [LEVELS:0][WIDTH-1:0] xor_tree;
        assign xor_tree[0] = in;
        for (genvar lvl = 0; lvl < LEVELS; lvl = lvl + 1) begin : xor_gen
            for (genvar i = 0; i < ((WIDTH-1) >> (lvl+1)) + 1; i = i + 1) begin
                assign xor_tree[lvl+1][i] = ^xor_tree[lvl][i*GROUP_SIZE +: GROUP_SIZE];
            end
        end
        assign out_xor = xor_tree[LEVELS][0];
    endgenerate

endmodule