module ROM (
    input [7:0] addr,
    output [15:0] dout
);

    // Memory array: 256x16 ROM (parameterizable by changing array size)
    reg [15:0] mem [0:255];

    // Complete initialization - no X-states
    initial begin
        // Explicit known values
        mem[0] = 16'hA0A0;
        mem[1] = 16'hB1B1;
        mem[2] = 16'hC2C2;
        mem[3] = 16'hD3D3;
        
        // Initialize remaining locations to zero
        // (Prevents X-propagation and reduces switching power)
        for (int i = 4; i < 256; i = i + 1) begin
            mem[i] = 16'h0000;
        end
        
        /* Alternative Initialization Patterns (uncomment as needed):
         * // Linear fill:    mem[i] = i;
         * // Checkerboard:   mem[i] = (i%2) ? 16'h5555 : 16'hAAAA;
         * // Increment by 4: mem[i] = i << 2;
         */
    end

    // Efficient combinational read path
    assign dout = mem[addr];

    /* Optimization Notes:
     * - For high-speed: Add output register stage
     * - For low-power:  Add read-enable signal to gate outputs
     * - For small ROMs: Replace array with case statement (<16 entries)
     * - For large ROMs: Consider block RAM implementation
     */
endmodule