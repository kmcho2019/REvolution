// Define a module for extracting a specified range of bits from the input
module ByteExtractor #(
    parameter INPUT_WIDTH = 16,
    parameter OUTPUT_WIDTH = 8,
    parameter OFFSET = 0
) (
    input  [INPUT_WIDTH-1:0] in,
    output [OUTPUT_WIDTH-1:0] out
);

    // Use a continuous assignment to extract the specified range of bits
    assign out = in[OFFSET + OUTPUT_WIDTH - 1:OFFSET];

endmodule

// Define a flexible bit splitter module
module FlexibleBitSplitter #(
    parameter INPUT_WIDTH = 16,
    parameter SPLIT_POINT = 8,
    parameter OUT_HI_WIDTH = 8,
    parameter OUT_LO_WIDTH = 8
) (
    input  [INPUT_WIDTH-1:0] in,
    output [OUT_HI_WIDTH-1:0] out_hi,
    output [OUT_LO_WIDTH-1:0] out_lo
);

    // Instantiate the ByteExtractor for the high byte
    ByteExtractor #(
        .INPUT_WIDTH(INPUT_WIDTH),
        .OUTPUT_WIDTH(OUT_HI_WIDTH),
        .OFFSET(SPLIT_POINT)
    ) high_byte_extractor(
        .in(in),
        .out(out_hi)
    );

    // Instantiate the ByteExtractor for the low byte
    ByteExtractor #(
        .INPUT_WIDTH(INPUT_WIDTH),
        .OUTPUT_WIDTH(OUT_LO_WIDTH),
        .OFFSET(0)
    ) low_byte_extractor(
        .in(in),
        .out(out_lo)
    );

endmodule

// Define the TopModule that instantiates the FlexibleBitSplitter
module TopModule(
    input  [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);

    // Instantiate the FlexibleBitSplitter with the desired parameters
    FlexibleBitSplitter #(
        .INPUT_WIDTH(16),
        .SPLIT_POINT(8),
        .OUT_HI_WIDTH(8),
        .OUT_LO_WIDTH(8)
    ) splitter(
        .in(in),
        .out_hi(out_hi),
        .out_lo(out_lo)
    );

endmodule