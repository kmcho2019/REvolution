module SignExtend #(
    parameter REPLICATION_COUNT = 24,
    parameter INPUT_WIDTH = 8,
    parameter OUTPUT_WIDTH = 32
) (
    input [INPUT_WIDTH-1:0] in,
    output [OUTPUT_WIDTH-1:0] out
);

    // Directly assign the replicated MSB and the input to the output
    // using a technique to minimize unnecessary switching activity
    assign out = (in[INPUT_WIDTH-1]) ? { {REPLICATION_COUNT{1'b1}}, in } : { {REPLICATION_COUNT{1'b0}}, in };

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