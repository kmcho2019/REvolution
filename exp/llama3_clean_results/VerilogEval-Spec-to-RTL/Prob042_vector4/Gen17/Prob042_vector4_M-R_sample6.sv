module SignExtend #(
    parameter REPLICATION_COUNT = 24,
    parameter INPUT_WIDTH = 8,
    parameter OUTPUT_WIDTH = 32
) (
    input [INPUT_WIDTH-1:0] in,
    output [OUTPUT_WIDTH-1:0] out
);

    localparam SIGN_BIT_INDEX = INPUT_WIDTH - 1;

    // Use ternary operator to fill the output with MSB or the input
    assign out = { {(OUTPUT_WIDTH - INPUT_WIDTH){in[SIGN_BIT_INDEX]}}, in };

endmodule

module TopModule (
    input [7:0] in,
    output [31:0] out
);

    SignExtend #(
        .REPLICATION_COUNT(24),
        .INPUT_WIDTH(8),
        .OUTPUT_WIDTH(32)
    ) se (.in(in), .out(out));

endmodule