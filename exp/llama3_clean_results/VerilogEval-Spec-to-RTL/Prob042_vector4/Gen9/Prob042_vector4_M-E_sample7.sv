module TopModule #(
    parameter INPUT_WIDTH = 8,
    parameter OUTPUT_WIDTH = 32
) (
    input [INPUT_WIDTH-1:0] in,
    output [OUTPUT_WIDTH-1:0] out
);

    // Use ternary operator to select between ones and zeros for the upper bits
    assign out = (in[INPUT_WIDTH-1] == 1'b1)? { {OUTPUT_WIDTH-INPUT_WIDTH{1'b1}}, in } : { {OUTPUT_WIDTH-INPUT_WIDTH{1'b0}}, in };

endmodule