module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Binary tree reduction for AND operation
    wire [126:0] and_tree; // Enough nodes for 100 inputs (next power of 2)
    assign and_tree[99:0] = in;
    
    genvar i;
    generate
        for (i = 0; i < 7; i = i + 1) begin : and_tree_gen
            integer j;
            for (j = 0; j < (100 >> (i+1)); j = j + 1) begin
                assign and_tree[(100 >> i) + j] = 
                    and_tree[(j << 1) + (100 >> i) - (100 >> (i+1))] & 
                    and_tree[(j << 1 | 1) + (100 >> i) - (100 >> (i+1))];
            end
        end
    endgenerate
    assign out_and = and_tree[126];

    // Binary tree reduction for OR operation
    wire [126:0] or_tree;
    assign or_tree[99:0] = in;
    
    genvar k;
    generate
        for (k = 0; k < 7; k = k + 1) begin : or_tree_gen
            integer m;
            for (m = 0; m < (100 >> (k+1)); m = m + 1) begin
                assign or_tree[(100 >> k) + m] = 
                    or_tree[(m << 1) + (100 >> k) - (100 >> (k+1))] | 
                    or_tree[(m << 1 | 1) + (100 >> k) - (100 >> (k+1))];
            end
        end
    endgenerate
    assign out_or = or_tree[126];

    // XOR operation (reduction operator is optimal)
    assign out_xor = ^in;

endmodule