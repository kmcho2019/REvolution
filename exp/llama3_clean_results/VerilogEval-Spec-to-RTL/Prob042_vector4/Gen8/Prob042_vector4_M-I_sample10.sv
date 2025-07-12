module TopModule #(
    parameter INPUT_WIDTH = 8,
    parameter OUTPUT_WIDTH = 32
) (
    input [INPUT_WIDTH-1:0] in,
    output [OUTPUT_WIDTH-1:0] out
);

    // Directly use the sign bit to decide the upper bits
    assign out = { {(in[INPUT_WIDTH-1]? 1'b1 : 1'b0) {OUTPUT_WIDTH-INPUT_WIDTH}}, in };

endmodule