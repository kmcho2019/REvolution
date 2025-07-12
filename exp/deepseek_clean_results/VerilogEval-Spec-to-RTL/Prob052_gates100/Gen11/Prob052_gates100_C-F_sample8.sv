module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Parameterized width
    localparam WIDTH = 100;
    localparam LEVELS = $clog2(WIDTH);

    // Binary tree reduction for AND
    wire [WIDTH-1:0] and_tree [0:LEVELS];
    assign and_tree[0] = in;
    genvar i, j;
    generate
        for (i = 0; i < LEVELS; i = i + 1) begin : and_tree_gen
            for (j = 0; j < (WIDTH+(1<<i)-1)/(1<<(i+1)); j = j + 1) begin : and_level
                if (j*2+1 < (WIDTH+(1<<i)-1)/(1<<i))) begin
                    assign and_tree[i+1][j] = and_tree[i][j*2] & and_tree[i][j*2+1];
                end else begin
                    assign and_tree[i+1][j] = and_tree[i][j*2];
                end
            end
        end
    endgenerate
    assign out_and = and_tree[LEVELS][0];

    // Binary tree reduction for OR
    wire [WIDTH-1:0] or_tree [0:LEVELS];
    assign or_tree[0] = in;
    generate
        for (i = 0; i < LEVELS; i = i + 1) begin : or_tree_gen
            for (j = 0; j < (WIDTH+(1<<i)-1)/(1<<(i+1)); j = j + 1) begin : or_level
                if (j*2+1 < (WIDTH+(1<<i)-1)/(1<<i))) begin
                    assign or_tree[i+1][j] = or_tree[i][j*2] | or_tree[i][j*2+1];
                end else begin
                    assign or_tree[i+1][j] = or_tree[i][j*2];
                end
            end
        end
    endgenerate
    assign out_or = or_tree[LEVELS][0];

    // XOR as reduction operator (most efficient)
    assign out_xor = ^in;

endmodule