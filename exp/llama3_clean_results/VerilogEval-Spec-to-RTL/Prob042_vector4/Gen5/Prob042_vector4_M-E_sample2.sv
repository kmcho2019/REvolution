module TopModule #(
    parameter REPLICATION_COUNT = 24,
    parameter INPUT_WIDTH = 8,
    parameter OUTPUT_WIDTH = 32
) (
    input [INPUT_WIDTH-1:0] in,
    output [OUTPUT_WIDTH-1:0] out
);

// Calculate the shift amount for the input
localparam SHIFT_AMOUNT = OUTPUT_WIDTH - INPUT_WIDTH;

// Perform sign extension using shift and OR operations
assign out = (in[INPUT_WIDTH-1] ? (~0 << SHIFT_AMOUNT) : 0) | (in << SHIFT_AMOUNT);

endmodule