// Define the SignExtend module with parameters for replication count, input width, and output width
module SignExtend #(
    parameter REPLICATION_COUNT = 24,
    parameter INPUT_WIDTH = 8,
    parameter OUTPUT_WIDTH = 32
) (
    input [INPUT_WIDTH-1:0] in,
    output [OUTPUT_WIDTH-1:0] out
);

    // Directly assign the replicated MSB and the input to the output
    assign out = { {REPLICATION_COUNT{in[INPUT_WIDTH-1]}}, in };

endmodule

// Define the TopModule with the required interface
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

endmodule