module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Tree reduction module for any binary operation
    module TreeReducer #(
        parameter WIDTH = 100,
        parameter OP = "AND"  // "AND", "OR", or "XOR"
    ) (
        input [WIDTH-1:0] data,
        output result
    );
        generate
            if (WIDTH == 1) begin
                assign result = data;
            end
            else begin
                localparam LEFT_SIZE = WIDTH / 2;
                localparam RIGHT_SIZE = WIDTH - LEFT_SIZE;
                
                wire left_result, right_result;
                
                TreeReducer #(LEFT_SIZE, OP) left_tree(
                    .data(data[LEFT_SIZE-1:0]),
                    .result(left_result)
                );
                
                TreeReducer #(RIGHT_SIZE, OP) right_tree(
                    .data(data[WIDTH-1:LEFT_SIZE]),
                    .result(right_result)
                );
                
                if (OP == "AND") begin
                    assign result = left_result & right_result;
                end
                else if (OP == "OR") begin
                    assign result = left_result | right_result;
                end
                else if (OP == "XOR") begin
                    assign result = left_result ^ right_result;
                end
            end
        endgenerate
    endmodule

    // Instantiate tree reducers for each operation
    TreeReducer #(100, "AND") and_tree(.data(in), .result(out_and));
    TreeReducer #(100, "OR")  or_tree(.data(in), .result(out_or));
    TreeReducer #(100, "XOR") xor_tree(.data(in), .result(out_xor));

endmodule