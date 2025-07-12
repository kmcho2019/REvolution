module TopModule #(
    parameter INPUT_WIDTH = 8,
    parameter OUTPUT_WIDTH = 32
) (
    input [INPUT_WIDTH-1:0] in,
    output [OUTPUT_WIDTH-1:0] out
);

// Calculate the number of bits to shift
localparam SHIFT_AMOUNT = OUTPUT_WIDTH - INPUT_WIDTH;

// Perform the sign extension using bitwise operations
assign out = ({SHIFT_AMOUNT{1'b0}, in} >>> (SHIFT_AMOUNT - 1)) | (in << SHIFT_AMOUNT);

endmodule