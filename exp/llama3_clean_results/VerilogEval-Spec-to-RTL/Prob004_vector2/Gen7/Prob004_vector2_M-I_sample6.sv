module TopModule (
    input  wire [31:0] in,  // 32-bit input vector
    output wire [31:0] out  // 32-bit output vector with bytes reversed
);

    // Define constants for byte positions
    localparam BYTE_WIDTH = 8;
    localparam NUM_BYTES = 4;

    // Reverse byte order using bitwise shifts and concatenations
    assign out = {
        in[(NUM_BYTES-1)*BYTE_WIDTH - 1 : (NUM_BYTES-1)*BYTE_WIDTH - BYTE_WIDTH],  // Last byte
        in[(NUM_BYTES-2)*BYTE_WIDTH - 1 : (NUM_BYTES-2)*BYTE_WIDTH - BYTE_WIDTH],  // Second last byte
        in[(NUM_BYTES-3)*BYTE_WIDTH - 1 : (NUM_BYTES-3)*BYTE_WIDTH - BYTE_WIDTH],  // Third last byte
        in[(NUM_BYTES-4)*BYTE_WIDTH - 1 : (NUM_BYTES-4)*BYTE_WIDTH - BYTE_WIDTH]   // First byte
    };

endmodule