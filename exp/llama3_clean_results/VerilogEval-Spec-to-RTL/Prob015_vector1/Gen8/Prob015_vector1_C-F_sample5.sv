module SuperiorSplitter #(
    parameter INPUT_WIDTH = 16,
    parameter SPLIT_POINT = 8
) (
    input  [INPUT_WIDTH-1:0] in,
    output [SPLIT_POINT-1:0] out_hi,
    output [INPUT_WIDTH-SPLIT_POINT-1:0] out_lo
);

    // Directly assigning the upper and lower parts of the input to the outputs
    // This approach maintains flexibility through parameters while avoiding macro overhead
    assign out_hi = in[INPUT_WIDTH-1:INPUT_WIDTH-SPLIT_POINT];
    assign out_lo = in[SPLIT_POINT-1:0];

endmodule

module TopModule(
    input  [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);

    // Instantiating the SuperiorSplitter module with specified parameters
    SuperiorSplitter #(
        .INPUT_WIDTH(16),
        .SPLIT_POINT(8)
    ) splitter(
        .in(in),
        .out_hi(out_hi),
        .out_lo(out_lo)
    );

endmodule