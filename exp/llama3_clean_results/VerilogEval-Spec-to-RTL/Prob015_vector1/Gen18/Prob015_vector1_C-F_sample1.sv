// Define a parameterizable module for the input splitting logic
module TopModule #(
    parameter INPUT_WIDTH = 16,
    parameter SPLIT_POINT = 8,
    parameter OUTPUT_WIDTH_HI = 8,
    parameter OUTPUT_WIDTH_LO = 8
) (
    input  [INPUT_WIDTH-1:0] in,
    output [OUTPUT_WIDTH_HI-1:0] out_hi,
    output [OUTPUT_WIDTH_LO-1:0] out_lo
);

    // Directly assign the input bits to the output ports for efficiency and simplicity
    assign out_hi = in[INPUT_WIDTH-1:INPUT_WIDTH-SPLIT_POINT];
    assign out_lo = in[SPLIT_POINT-1:0];

endmodule