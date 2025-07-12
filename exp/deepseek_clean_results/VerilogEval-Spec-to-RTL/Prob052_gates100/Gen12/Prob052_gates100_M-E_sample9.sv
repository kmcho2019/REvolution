module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Base case module for leaf nodes
    module ReductionLeaf #(parameter WIDTH=1) (
        input [WIDTH-1:0] in,
        output out_and,
        output out_or,
        output out_xor
    );
        assign out_and = &in;
        assign out_or = |in;
        assign out_xor = ^in;
    endmodule

    // Recursive tree node module
    module ReductionNode #(parameter WIDTH=1) (
        input [WIDTH-1:0] in,
        output out_and,
        output out_or,
        output out_xor
    );
        localparam LEFT_WIDTH = WIDTH / 2;
        localparam RIGHT_WIDTH = WIDTH - LEFT_WIDTH;
        
        wire left_and, left_or, left_xor;
        wire right_and, right_or, right_xor;
        
        if (LEFT_WIDTH <= 2) begin
            ReductionLeaf #(LEFT_WIDTH) left (
                .in(in[LEFT_WIDTH-1:0]),
                .out_and(left_and),
                .out_or(left_or),
                .out_xor(left_xor)
            );
        end else begin
            ReductionNode #(LEFT_WIDTH) left (
                .in(in[LEFT_WIDTH-1:0]),
                .out_and(left_and),
                .out_or(left_or),
                .out_xor(left_xor)
            );
        end
        
        if (RIGHT_WIDTH <= 2) begin
            ReductionLeaf #(RIGHT_WIDTH) right (
                .in(in[WIDTH-1:LEFT_WIDTH]),
                .out_and(right_and),
                .out_or(right_or),
                .out_xor(right_xor)
            );
        end else begin
            ReductionNode #(RIGHT_WIDTH) right (
                .in(in[WIDTH-1:LEFT_WIDTH]),
                .out_and(right_and),
                .out_or(right_or),
                .out_xor(right_xor)
            );
        end
        
        assign out_and = left_and & right_and;
        assign out_or = left_or | right_or;
        assign out_xor = left_xor ^ right_xor;
    endmodule

    // Instantiate the complete tree
    ReductionNode #(100) tree (
        .in(in),
        .out_and(out_and),
        .out_or(out_or),
        .out_xor(out_xor)
    );

endmodule