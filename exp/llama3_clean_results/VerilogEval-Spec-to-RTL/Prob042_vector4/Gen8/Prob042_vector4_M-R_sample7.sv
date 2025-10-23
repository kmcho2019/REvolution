module TopModule #(
    parameter INPUT_WIDTH = 8,
    parameter OUTPUT_WIDTH = 32
) (
    input [INPUT_WIDTH-1:0] in,
    output [OUTPUT_WIDTH-1:0] out
);

    localparam REPLICATION_COUNT = OUTPUT_WIDTH - INPUT_WIDTH;
    wire sign_bit = in[INPUT_WIDTH-1];

    // Assign the replicated MSB concatenated with the input to the output
    assign out = { {REPLICATION_COUNT{sign_bit}}, in };

endmodule