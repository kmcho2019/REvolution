module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Parameterized width for flexibility
    localparam WIDTH = 100;
    
    // Tree reduction for AND using generate blocks
    wire [127:0] and_tree;  // Next power of 2 (128)
    assign and_tree[WIDTH-1:0] = in;
    assign and_tree[127:WIDTH] = {128-WIDTH{1'b1}};  // Pad with 1's for AND
    
    genvar i;
    generate
        for (i = 0; i < 7; i = i + 1) begin : and_tree_gen
            wire [127>>(i+1)-1:0] stage;
            for (genvar j = 0; j < (128>>i); j = j + 2) begin
                assign stage[j/2] = and_tree[j] & and_tree[j+1];
            end
            assign and_tree = stage;
        end
    endgenerate
    assign out_and = and_tree[0];

    // Tree reduction for OR using generate blocks
    wire [127:0] or_tree;
    assign or_tree[WIDTH-1:0] = in;
    assign or_tree[127:WIDTH] = {128-WIDTH{1'b0}};  // Pad with 0's for OR
    
    generate
        for (i = 0; i < 7; i = i + 1) begin : or_tree_gen
            wire [127>>(i+1)-1:0] stage;
            for (genvar j = 0; j < (128>>i); j = j + 2) begin
                assign stage[j/2] = or_tree[j] | or_tree[j+1];
            end
            assign or_tree = stage;
        end
    endgenerate
    assign out_or = or_tree[0];

    // XOR reduction - keep as reduction operator but make explicit
    assign out_xor = ^in;

endmodule