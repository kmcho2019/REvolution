module TopModule (
    input  wire [31:0] in,  // 32-bit input vector
    output wire [31:0] out  // 32-bit output vector with bytes reversed
);

    // Define the number of bytes in the input vector
    localparam NUM_BYTES = 32 / 8;

    // Use a for-loop to generate the reversed byte order
    // This approach allows for scalability and flexibility
    genvar i;
    generate
        for (i = 0; i < NUM_BYTES; i++) begin
            // Assign each byte of the input vector to the output vector in reverse order
            // This is done by using the expression ((NUM_BYTES - 1 - i) * 8) +: 8 to reverse the byte order
            assign out[(i * 8) +: 8] = in[((NUM_BYTES - 1 - i) * 8) +: 8];
        end
    endgenerate

endmodule