module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Parameterized reduction tree module
    module reduction_tree #(
        parameter WIDTH = 100,
        parameter OP = "AND"  // "AND", "OR", or "XOR"
    ) (
        input [WIDTH-1:0] in,
        output out
    );
        generate
            if (WIDTH == 1) begin
                assign out = in;
            end
            else if (WIDTH == 2) begin
                if (OP == "AND") assign out = in[0] & in[1];
                else if (OP == "OR") assign out = in[0] | in[1];
                else if (OP == "XOR") assign out = in[0] ^ in[1];
            end
            else begin
                localparam LEFT_WIDTH = WIDTH / 2;
                localparam RIGHT_WIDTH = WIDTH - LEFT_WIDTH;
                
                wire left_out, right_out;
                
                reduction_tree #(
                    .WIDTH(LEFT_WIDTH),
                    .OP(OP)
                ) left_tree (
                    .in(in[LEFT_WIDTH-1:0]),
                    .out(left_out)
                );
                
                reduction_tree #(
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

    // Instantiate reduction trees for each operation
    reduction_tree #(.WIDTH(100), .OP("AND")) and_tree (.in(in), .out(out_and));
    reduction_tree #(.WIDTH(100), .OP("OR")) or_tree (.in(in), .out(out_or));
    reduction_tree #(.WIDTH(100), .OP("XOR")) xor_tree (.in(in), .out(out_xor));

endmodule