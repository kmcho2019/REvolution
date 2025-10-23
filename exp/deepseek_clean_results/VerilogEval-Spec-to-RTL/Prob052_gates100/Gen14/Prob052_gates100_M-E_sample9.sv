module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // AND tree reduction
    TreeReducer #(
        .WIDTH(100),
        .OP("AND")
    ) and_tree (
        .in(in),
        .out(out_and)
    );
    
    // OR tree reduction
    TreeReducer #(
        .WIDTH(100),
        .OP("OR")
    ) or_tree (
        .in(in),
        .out(out_or)
    );
    
    // XOR tree reduction
    TreeReducer #(
        .WIDTH(100),
        .OP("XOR")
    ) xor_tree (
        .in(in),
        .out(out_xor)
    );

endmodule

module TreeReducer #(
    parameter WIDTH = 100,
    parameter OP = "AND"
) (
    input [WIDTH-1:0] in,
    output out
);
    
    generate
        if (WIDTH == 1) begin
            // Base case - single input
            assign out = in[0];
        end
        else if (WIDTH == 2) begin
            // Base case - two inputs
            if (OP == "AND") assign out = in[0] & in[1];
            else if (OP == "OR") assign out = in[0] | in[1];
            else if (OP == "XOR") assign out = in[0] ^ in[1];
        end
        else begin
            // Recursive case - split into two subtrees
            localparam LEFT_WIDTH = WIDTH / 2;
            localparam RIGHT_WIDTH = WIDTH - LEFT_WIDTH;
            
            wire left_out, right_out;
            
            TreeReducer #(
                .WIDTH(LEFT_WIDTH),
                .OP(OP)
            ) left_tree (
                .in(in[LEFT_WIDTH-1:0]),
                .out(left_out)
            );
            
            TreeReducer #(
                .WIDTH(RIGHT_WIDTH),
                .OP(OP)
            ) right_tree (
                .in(in[WIDTH-1:LEFT_WIDTH]),
                .out(right_out)
            );
            
            if (OP == "AND") assign out = left_out & right_out;
            else if (OP == "OR") assign out = left_out | right_out;
            else if (OP == "XOR") assign out = left_out ^ right_out;
        end
    endgenerate

endmodule