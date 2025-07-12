module ROM (
    input [7:0] addr,
    output [15:0] dout
);

    // Memory array: 256x16 ROM
    reg [15:0] mem [0:255];

    // Initialization - choose one pattern below
    initial begin
        // Basic initialization (as specified)
        mem[0] = 16'hA0A0;
        mem[1] = 16'hB1B1;
        mem[2] = 16'hC2C2;
        mem[3] = 16'hD3D3;

        // Alternative patterns (uncomment as needed):
        // 1. Zero-fill unused locations
        // for (int i=4; i<256; i=i+1) mem[i] = 16'h0000;
        
        // 2. Incrementing pattern
        // for (int i=4; i<256; i=i+1) mem[i] = i;
        
        // 3. Custom function pattern example
        // for (int i=4; i<256; i=i+1) mem[i] = (i << 8) | (i & 8'hFF);
    end

    // Direct memory access (combinational)
    assign dout = mem[addr];

    /* Design Optimization Notes:
     * Power:
     * - Add clock gating if ROM is only accessed periodically
     * - Consider registered output with read-enable to reduce switching
     *
     * Area:
     * - For <16 used locations: Replace with case statement
     * - For patterned data: Implement as function rather than storage
     *
     * Performance:
     * - Register output for high-frequency operation
     * - Pipeline address for multi-cycle access if needed
     */

endmodule