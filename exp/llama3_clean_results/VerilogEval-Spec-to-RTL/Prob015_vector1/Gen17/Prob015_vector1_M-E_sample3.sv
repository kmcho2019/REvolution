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

// Define the TopModule that instantiates the ByteExtractor for high and low bytes
module TopModule(
    input  [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);

    // Instantiate the ByteExtractor for the high byte
    ByteExtractor #(
        .INPUT_WIDTH(16),
        .OUTPUT_WIDTH(8),
        .OFFSET(8)
    ) high_byte_extractor(
        .in(in),
        .out(out_hi)
    );

    // Instantiate the ByteExtractor for the low byte
    ByteExtractor #(
        .INPUT_WIDTH(16),
        .OUTPUT_WIDTH(8),
        .OFFSET(0)
    ) low_byte_extractor(
        .in(in),
        .out(out_lo)
    );

endmodule