module TopModule #(
    parameter INPUT_WIDTH = 8,
    parameter OUTPUT_WIDTH = 32,
    parameter REPLICATION_COUNT = OUTPUT_WIDTH - INPUT_WIDTH
) (
    input [INPUT_WIDTH-1:0] in,
    output [OUTPUT_WIDTH-1:0] out
);

    // Directly assign the replicated MSB and the input to the output
    assign out = { {REPLICATION_COUNT{in[INPUT_WIDTH-1]}}, in };

endmodule