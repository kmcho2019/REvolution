module TopModule #(
    parameter WIDTH = 32  // Parameter for vector width
)(
    input  wire [WIDTH-1:0] in,  // Input vector
    output reg [WIDTH-1:0] out  // Output vector with bytes reversed
);

    // Calculate the number of bytes in the vector
    localparam NUM_BYTES = WIDTH / 8;

    // Directly assign the bytes of the input vector to the output vector in reverse order
    always @(*) begin
        // Initialize the output vector
        out = '0;
        
        // Reverse the byte order
        for (int i = 0; i < NUM_BYTES; i++) begin
            out[(i*8)+:8] = in[((NUM_BYTES-1-i)*8)+:8];
        end
    end

endmodule