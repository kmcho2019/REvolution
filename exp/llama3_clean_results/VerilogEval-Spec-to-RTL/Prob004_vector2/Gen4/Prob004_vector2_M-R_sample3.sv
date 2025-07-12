module TopModule #(
    parameter INPUT_WIDTH = 32,
    parameter BYTE_SIZE = 8
) (
    input  wire [INPUT_WIDTH-1:0] in,
    output wire [INPUT_WIDTH-1:0] out
);

    localparam NUM_BYTES = INPUT_WIDTH / BYTE_SIZE;

    assign out = {
        in[(NUM_BYTES-1)*BYTE_SIZE-1 : (NUM_BYTES-1)*BYTE_SIZE-BYTE_SIZE],
        in[(NUM_BYTES-2)*BYTE_SIZE-1 : (NUM_BYTES-2)*BYTE_SIZE-BYTE_SIZE],
        in[(NUM_BYTES-3)*BYTE_SIZE-1 : (NUM_BYTES-3)*BYTE_SIZE-BYTE_SIZE],
        in[(NUM_BYTES-4)*BYTE_SIZE-1 : (NUM_BYTES-4)*BYTE_SIZE-BYTE_SIZE]
    };

    // However, for better generality and scalability, a loop or a more dynamic approach would be ideal.
    // Unfortunately, Verilog does not support dynamic bit slicing in the same way as some other languages,
    // so we would typically use a generate statement for more complex, parameterized designs.

endmodule