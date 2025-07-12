module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Tree reduction function for any binary operation
    function automatic logic tree_reduce(input [99:0] vec, input string op);
        logic [6:0][199:0] tree; // Extra space for intermediate results
        integer i, j, level_size;
        
        // Initialize leaves
        for (i = 0; i < 100; i = i + 1) begin
            tree[0][i] = vec[i];
        end
        
        // Build reduction tree
        for (i = 0; i < 6; i = i + 1) begin
            level_size = 100 >> i;
            for (j = 0; j < (level_size + 1)/2; j = j + 1) begin
                case (op)
                    "AND": tree[i+1][j] = tree[i][2*j] & (2*j+1 < level_size ? tree[i][2*j+1] : 1'b1);
                    "OR":  tree[i+1][j] = tree[i][2*j] | (2*j+1 < level_size ? tree[i][2*j+1] : 1'b0);
                    "XOR": tree[i+1][j] = tree[i][2*j] ^ (2*j+1 < level_size ? tree[i][2*j+1] : 1'b0);
                endcase
            end
        end
        
        // Final result is at the root of the tree
        return tree[6][0];
    endfunction

    assign out_and = tree_reduce(in, "AND");
    assign out_or  = tree_reduce(in, "OR");
    assign out_xor = tree_reduce(in, "XOR");

endmodule