module ROM (
    input [7:0] addr,
    output reg [15:0] dout
);

    // Memory array declaration: 256 locations of 16-bit data
    reg [15:0] mem [0:255];

    // Initialize memory contents
    initial begin
        // Example initialization of specific locations
        mem[0] = 16'hA0A0;
        mem[1] = 16'hB1B1;
        mem[2] = 16'hC2C2;
        mem[3] = 16'hD3D3;
        
        // Uncomment to explicitly initialize remaining locations to zero
        // for (int i = 4; i < 256; i = i + 1) begin
        //     mem[i] = 16'h0000;
        // end
        
        // Alternative: Initialize with custom pattern if needed
        // for (int i = 4; i < 256; i = i + 1) begin
        //     mem[i] = i; // Simple incrementing pattern example
        // end
    end

    // Continuous read operation (combinational)
    always @(*) begin
        dout = mem[addr];
    end

    /* Design Optimization Notes:
     * 1. For power-sensitive designs: Consider adding an output register
     *    with read-enable signal to reduce switching activity
     * 2. For area optimization: If only few locations are non-zero,
     *    consider sparse implementation using case statement
     * 3. For high-frequency designs: Register the output to improve timing
     */

endmodule