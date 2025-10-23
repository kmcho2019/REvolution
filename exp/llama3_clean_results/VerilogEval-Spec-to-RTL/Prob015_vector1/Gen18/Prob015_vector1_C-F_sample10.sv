// Define a macro for the split operation
`define SPLIT_INPUT(SIG_IN, SIG_OUT_HI, SIG_OUT_LO, WIDTH_IN, WIDTH_OUT) \
    assign SIG_OUT_HI = SIG_IN[(WIDTH_IN - 1) : (WIDTH_IN - WIDTH_OUT)]; \
    assign SIG_OUT_LO = SIG_IN[(WIDTH_OUT - 1) : 0];

// Parameterizable module for splitting the input
module TopModule #(
    parameter INPUT_WIDTH = 16,
    parameter SPLIT_POINT = 8
) (
    input  [INPUT_WIDTH-1:0] in,
    output [SPLIT_POINT-1:0] out_hi,
    output [INPUT_WIDTH-SPLIT_POINT-1:0] out_lo
);

    // Use the macro to perform the split operation
    `SPLIT_INPUT(in, out_hi, out_lo, INPUT_WIDTH, SPLIT_POINT);

endmodule