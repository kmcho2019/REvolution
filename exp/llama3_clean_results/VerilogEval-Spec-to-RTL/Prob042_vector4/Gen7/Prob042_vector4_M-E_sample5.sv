module TopModule #(
    parameter INPUT_WIDTH = 8,
    parameter OUTPUT_WIDTH = 32
) (
    input [INPUT_WIDTH-1:0] in,
    output [OUTPUT_WIDTH-1:0] out
);

    // Check the sign bit of the input
    assign out = (in[INPUT_WIDTH-1] == 1'b0) ? 
                 { {OUTPUT_WIDTH-INPUT_WIDTH{1'b0}}, in } : 
                 { {OUTPUT_WIDTH-INPUT_WIDTH{1'b1}}, in };

endmodule