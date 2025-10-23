module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Parameter for input width
    localparam WIDTH = 100;

    // AND operation as tree reduction
    wire [WIDTH-1:0] and_tree;
    assign and_tree[0] = in[0];
    generate
        for (genvar i = 1; i < WIDTH; i = i + 1) begin : and_tree_gen
            assign and_tree[i] = and_tree[i-1] & in[i];
        end
    endgenerate
    assign out_and = and_tree[WIDTH-1];

    // OR operation as tree reduction
    wire [WIDTH-1:0] or_tree;
    assign or_tree[0] = in[0];
    generate
        for (genvar i = 1; i < WIDTH; i = i + 1) begin : or_tree_gen
            assign or_tree[i] = or_tree[i-1] | in[i];
        end
    endgenerate
    assign out_or = or_tree[WIDTH-1];

    // XOR operation using reduction operator
    assign out_xor = ^in;

endmodule