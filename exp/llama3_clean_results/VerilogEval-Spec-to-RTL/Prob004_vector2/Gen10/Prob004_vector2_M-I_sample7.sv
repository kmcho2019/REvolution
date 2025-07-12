module TopModule #(
    parameter WIDTH = 32, // Total width of the input vector
    parameter BYTE_SIZE = 8 // Size of each byte in bits
) (
    input  wire [WIDTH-1:0] in, // Input vector
    output wire [WIDTH-1:0] out // Output vector with bytes reversed
);

    // Calculate the number of bytes in the input vector
    localparam NUM_BYTES = WIDTH / BYTE_SIZE;
    
    // Initialize the output vector
    wire [WIDTH-1:0] reversed_bytes;
    
    // Use a generate block to reverse the byte order
    genvar i;
    generate
        for (i = 0; i < NUM_BYTES; i++) begin
            assign reversed_bytes[(i*BYTE_SIZE)+:BYTE_SIZE] = in[(NUM_BYTES-1-i)*BYTE_SIZE +: BYTE_SIZE];
        end
    endgenerate
    
    // Assign the reversed bytes to the output
    assign out = reversed_bytes;

endmodule