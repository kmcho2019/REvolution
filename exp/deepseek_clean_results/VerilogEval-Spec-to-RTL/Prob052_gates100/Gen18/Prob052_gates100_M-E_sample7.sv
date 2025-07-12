module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Pad input to 128 bits (next power of 2) with neutral values
    wire [127:0] padded_in;
    assign padded_in[99:0] = in;
    assign padded_in[127:100] = {28{1'b1}}; // 1's for AND (neutral), will be optimized away

    // Tree reduction modules for each operation
    tree_reduction #(.OP("AND"), .WIDTH(128)) and_tree (.in(padded_in), .out(out_and));
    tree_reduction #(.OP("OR"),  .WIDTH(128)) or_tree  (.in(padded_in), .out(out_or));
    tree_reduction #(.OP("XOR"), .WIDTH(128)) xor_tree (.in(padded_in), .out(out_xor));

endmodule

module tree_reduction #(
    parameter OP = "AND",
    parameter WIDTH = 128
) (
    input [WIDTH-1:0] in,
    output out
);

    generate
        if (WIDTH == 1) begin
            assign out = in[0];
        end
        else begin
            // Split into two halves
            localparam HALF_WIDTH = WIDTH / 2;
            wire [HALF_WIDTH-1:0] first_half = in[HALF_WIDTH-1:0];
            wire [HALF_WIDTH-1:0] second_half = in[WIDTH-1:HALF_WIDTH];
            
            // Recursively reduce each half
            wire half_result1, half_result2;
            tree_reduction #(.OP(OP), .WIDTH(HALF_WIDTH)) tree1 (.in(first_half),  .out(half_result1));
            tree_reduction #(.OP(OP), .WIDTH(HALF_WIDTH)) tree2 (.in(second_half), .out(half_result2));
            
            // Combine results based on operation
            if (OP == "AND") begin
                assign out = half_result1 & half_result2;
            end
            else if (OP == "OR") begin
                assign out = half_result1 | half_result2;
            end
            else if (OP == "XOR") begin
                assign out = half_result1 ^ half_result2;
            end
        end
    endgenerate

endmodule