module ROM (
    input [7:0] addr,
    output [15:0] dout
);

    // Configurable memory parameters
    localparam MEM_DEPTH = 256;    // 2^8 address space
    localparam MEM_WIDTH = 16;     // 16-bit data width
    localparam USED_LOCATIONS = 4; // Number of initialized locations

    // Memory array declaration
    reg [MEM_WIDTH-1:0] mem [0:MEM_DEPTH-1];

    // Initialize memory contents
    initial begin
        initialize_memory();
    end

    // Continuous read operation - direct combinational path
    assign dout = mem[addr];

    // Memory initialization function
    function automatic void initialize_memory();
        // Initialize specific locations with application data
        mem[0] = 16'hA0A0;
        mem[1] = 16'hB1B1;
        mem[2] = 16'hC2C2;
        mem[3] = 16'hD3D3;
        
        // Explicitly initialize remaining locations to zero
        // This improves power predictability and simulation stability
        for (int i = USED_LOCATIONS; i < MEM_DEPTH; i = i + 1) begin
            mem[i] = {MEM_WIDTH{1'b0}};
        end
    endfunction

    /* Design Features:
     * - Pure combinational read path for minimum latency
     * - Complete memory initialization for predictable behavior
     * - Configurable via localparams for easy adaptation
     * - Modular initialization function for clean code organization
     * - Explicit zeroing of unused locations for better power characteristics
     * - No clock needed (true ROM behavior)
     */
endmodule