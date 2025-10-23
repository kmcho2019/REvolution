module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Parameterized tree reduction function
    function automatic logic tree_reduce;
        input [99:0] data;
        input string op;
        integer levels, i, j;
        logic [127:0] tree [0:6]; // 7 levels (2^7=128)
        begin
            // Initialize level 0
            for (i = 0; i < 100; i = i + 1)
                tree[0][i] = data[i];
            for (i = 100; i < 128; i = i + 1)
                tree[0][i] = (op == "AND") ? 1'b1 : 1'b0;
            
            // Tree reduction
            for (levels = 1; levels < 7; levels = levels + 1) begin
                for (j = 0; j < (128 >> levels); j = j + 1) begin
                    case (op)
                        "AND": tree[levels][j] = tree[levels-1][2*j] & tree[levels-1][2*j+1];
                        "OR":  tree[levels][j] = tree[levels-1][2*j] | tree[levels-1][2*j+1];
                        "XOR": tree[levels][j] = tree[levels-1][2*j] ^ tree[levels-1][2*j+1];
                    endcase
                end
            end
            
            // Final result
            tree_reduce = tree[6][0];
        end
    endfunction

    // Output assignments using tree reduction
    assign out_and = tree_reduce(in, "AND");
    assign out_or  = tree_reduce(in, "OR");
    assign out_xor = tree_reduce(in, "XOR");

endmodule