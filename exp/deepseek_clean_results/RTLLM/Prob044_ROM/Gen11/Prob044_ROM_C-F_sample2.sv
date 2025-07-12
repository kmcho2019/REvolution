module ROM (
    input [7:0] addr,
    output [15:0] dout
);

    // Memory array: 256x16 ROM (parameterizable width/depth)
    reg [15:0] mem [0:255];

    // Initialize with specific values
    initial begin
        // Core initialization
        mem[0] = 16'hA0A0;
        mem[1] = 16'hB1B1;
        mem[2] = 16'hC2C2;
        mem[3] = 16'hD3D3;
        
        // Uncomment for zero initialization of remaining locations
        // for (int i=4; i<256; i=i+1) mem[i] = 16'h0000;
        
        // Alternative patterns (uncomment as needed):
        // Linear fill: mem[i] = i;
        // Checkerboard: mem[i] = (i%2) ? 16'h5555 : 16'hAAAA;
    end

    // Combinational read path (most efficient implementation)
    assign dout = mem[addr];

    /* Optimization Notes:
     * - For power: Add output register with read-enable
     * - For area: Use case statement if <16 used locations
     * - For speed: Consider output pipelining if >500MHz
     */
endmodule