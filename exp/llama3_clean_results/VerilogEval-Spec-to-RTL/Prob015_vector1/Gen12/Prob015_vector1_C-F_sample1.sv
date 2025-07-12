// Define a parameterized macro to split the input into two parts
`define SPLIT_INPUT(SIG_IN, SIG_OUT_HI, SIG_OUT_LO, WIDTH_IN, WIDTH_OUT) \
    assign SIG_OUT_HI = SIG_IN[(WIDTH_IN - 1) : (WIDTH_IN - WIDTH_OUT)]; \
    assign SIG_OUT_LO = SIG_IN[(WIDTH_OUT - 1) : 0];

// Define a parameterizable module to perform the input splitting
module BitSplitter #(
    parameter INPUT_WIDTH = 16,
    parameter SPLIT_POINT = 8
) (
    input  [INPUT_WIDTH-1:0] in,
    output [SPLIT_POINT-1:0] out_hi,
    output [INPUT_WIDTH-SPLIT_POINT-1:0] out_lo
);

    // Use the parameterized macro to split the input
    `SPLIT_INPUT(in, out_hi, out_lo, INPUT_WIDTH, SPLIT_POINT);

endmodule

// Define the TopModule that instantiates the BitSplitter module
module TopModule(
    input  [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);

    // Instantiate the BitSplitter module with specified parameters
    BitSplitter #(
       .INPUT_WIDTH(16),
       .SPLIT_POINT(8)
    ) splitter(
       .in(in),
       .out_hi(out_hi),
       .out_lo(out_lo)
    );

endmodule