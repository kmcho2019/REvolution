module TopModule #(
    parameter REPLICATION_COUNT = 24,
    parameter INPUT_WIDTH = 8,
    parameter OUTPUT_WIDTH = 32
) (
    input [INPUT_WIDTH-1:0] in,
    output [OUTPUT_WIDTH-1:0] out
);

    assign out = (in[INPUT_WIDTH-1] == 1'b1) ? { {REPLICATION_COUNT{1'b1}}, in } : { {REPLICATION_COUNT{1'b0}}, in };

endmodule