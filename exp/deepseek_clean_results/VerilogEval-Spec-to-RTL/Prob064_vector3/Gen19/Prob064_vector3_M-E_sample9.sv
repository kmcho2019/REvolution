module TopModule (
    input [4:0] a, b, c, d, e, f,
    output reg [7:0] w, x, y, z
);

    reg [31:0] combined;

    always @(*) begin
        // Combine all inputs with two 1's at LSB
        combined = {a, b, c, d, e, f, 2'b11};
        
        // Extract each 8-bit output using shifting
        w = combined[31:24];  // First 8 bits
        x = combined[23:16];  // Next 8 bits
        y = combined[15:8];   // Next 8 bits
        z = combined[7:0];    // Last 8 bits (includes the two 1's)
    end

endmodule