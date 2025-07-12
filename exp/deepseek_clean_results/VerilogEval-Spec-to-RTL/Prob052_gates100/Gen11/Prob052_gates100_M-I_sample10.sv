module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Binary tree reduction for AND operation
    function automatic logic and_reduce(input [99:0] vec);
        logic [6:0][99:0] tree; // 7 levels needed for 100 inputs (2^7=128)
        tree[0] = vec;
        for (int lvl = 1; lvl <= 6; lvl++) begin
            for (int i = 0; i < (100 >> lvl); i++) begin
                tree[lvl][i] = tree[lvl-1][2*i] & tree[lvl-1][2*i+1];
            end
            // Handle odd number of inputs at each level
            if ((100 >> (lvl-1)) % 2) begin
                tree[lvl][(100 >> lvl)] = tree[lvl-1][100 >> (lvl-1) - 1];
            end
        end
        and_reduce = tree[6][0];
    endfunction

    // Binary tree reduction for OR operation
    function automatic logic or_reduce(input [99:0] vec);
        logic [6:0][99:0] tree;
        tree[0] = vec;
        for (int lvl = 1; lvl <= 6; lvl++) begin
            for (int i = 0; i < (100 >> lvl); i++) begin
                tree[lvl][i] = tree[lvl-1][2*i] | tree[lvl-1][2*i+1];
            end
            if ((100 >> (lvl-1)) % 2) begin
                tree[lvl][(100 >> lvl)] = tree[lvl-1][100 >> (lvl-1) - 1];
            end
        end
        or_reduce = tree[6][0];
    endfunction

    // Optimized XOR reduction (parity calculation)
    function automatic logic xor_reduce(input [99:0] vec);
        logic [6:0][99:0] tree;
        tree[0] = vec;
        for (int lvl = 1; lvl <= 6; lvl++) begin
            for (int i = 0; i < (100 >> lvl); i++) begin
                tree[lvl][i] = tree[lvl-1][2*i] ^ tree[lvl-1][2*i+1];
            end
            if ((100 >> (lvl-1)) % 2) begin
                tree[lvl][(100 >> lvl)] = tree[lvl-1][100 >> (lvl-1) - 1];
            end
        end
        xor_reduce = tree[6][0];
    endfunction

    assign out_and = and_reduce(in);
    assign out_or  = or_reduce(in);
    assign out_xor = xor_reduce(in);

endmodule