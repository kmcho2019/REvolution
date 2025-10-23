module SignExtend #(
    parameter INPUT_WIDTH = 8,
    parameter OUTPUT_WIDTH = 32
) (
    input [INPUT_WIDTH-1:0] in,
    output [OUTPUT_WIDTH-1:0] out
);

    localparam REPLICATION_COUNT = OUTPUT_WIDTH - INPUT_WIDTH;

    // Directly assign the replicated MSB and the input to the output within the module port
    SignExtend se (.out(out), .in({{REPLICATION_COUNT{in[INPUT_WIDTH-1]}}, in}));

endmodule

module TopModule (
    input [7:0] in,
    output [31:0] out
);

    SignExtend #(
        .INPUT_WIDTH(8),
        .OUTPUT_WIDTH(32)
    ) se (.in(in), .out(out));

endmodule