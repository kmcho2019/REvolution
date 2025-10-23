module SignExtend #(
    parameter REPLICATION_COUNT = 24,
    parameter INPUT_WIDTH = 8,
    parameter OUTPUT_WIDTH = 32
) (
    input [INPUT_WIDTH-1:0] in,
    output [OUTPUT_WIDTH-1:0] out
);

    // Directly assign the replicated MSB and the input to the output
    // Considering adding a buffer or register to the input to reduce power consumption
    // if the input data has a high toggle rate or specific patterns.
    assign out = { {REPLICATION_COUNT{in[INPUT_WIDTH-1]}}, in };

endmodule

module TopModule (
    input [7:0] in,
    output [31:0] out
);

    // Instantiate the SignExtend module with the required parameters
    SignExtend #(
        .REPLICATION_COUNT(24),
        .INPUT_WIDTH(8),
        .OUTPUT_WIDTH(32)
    ) se (.in(in), .out(out));

    // Consider adding a register or buffer to the input for power optimization
    // if the input data characteristics suggest it would be beneficial.

endmodule