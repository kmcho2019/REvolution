module SignExtend #(
    parameter INPUT_WIDTH = 8,
    parameter OUTPUT_WIDTH = 32,
    parameter REPLICATION_COUNT = OUTPUT_WIDTH - INPUT_WIDTH
) (
    input [INPUT_WIDTH-1:0] in,
    output [OUTPUT_WIDTH-1:0] out
);

    // Assign the replicated MSB concatenated with the input to the output
    assign out = (in[INPUT_WIDTH-1]) ? { {REPLICATION_COUNT{1'b1}}, in } : { {REPLICATION_COUNT{1'b0}}, in };

endmodule

module TopModule (
    input [7:0] in,
    output [31:0] out
);

    SignExtend #(.INPUT_WIDTH(8), .OUTPUT_WIDTH(32)) se (.in(in), .out(out));

endmodule