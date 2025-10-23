module TopModule(
    input  [31:0] in,
    output [31:0] out
);

    // Define the number of bytes in the input vector and their size
    localparam NUM_BYTES = 32 / 8;
    localparam BYTE_SIZE = 8;

    // Use a for-loop to generate the reversed byte order
    genvar i;
    generate
        for (i = 0; i < NUM_BYTES; i++) begin
            // Assign each byte of the input vector to the output vector in reverse order
            assign out[(i * BYTE_SIZE) +: BYTE_SIZE] = in[((NUM_BYTES - 1 - i) * BYTE_SIZE) +: BYTE_SIZE];
        end
    endgenerate

endmodule