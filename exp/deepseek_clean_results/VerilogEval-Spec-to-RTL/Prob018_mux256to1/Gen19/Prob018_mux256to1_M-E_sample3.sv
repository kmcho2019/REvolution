module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // Binary to one-hot decoder
    wire [255:0] one_hot;
    assign one_hot = (1 << sel);

    // Parallel bitwise AND
    wire [255:0] and_results;
    assign and_results = in & one_hot;

    // Massive OR reduction tree
    // Implemented as 8 levels of 2-input ORs
    wire [255:0] or_tree [0:7];
    assign or_tree[0] = and_results;

    genvar i, j;
    generate
        for (i = 1; i <= 7; i = i + 1) begin : or_level
            for (j = 0; j < (256 >> i); j = j + 1) begin : or_gates
                assign or_tree[i][j] = or_tree[i-1][2*j] | or_tree[i-1][2*j+1];
            end
        end
    endgenerate

    assign out = or_tree[7][0];

endmodule