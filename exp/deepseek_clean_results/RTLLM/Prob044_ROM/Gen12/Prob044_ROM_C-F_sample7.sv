module ROM (
    input [7:0] addr,
    output wire [15:0] dout
);

    // Memory dimensions
    localparam MEM_DEPTH = 256;
    localparam MEM_WIDTH = 16;
    
    // Memory array declaration
    reg [MEM_WIDTH-1:0] mem [0:MEM_DEPTH-1];

    // Initialize memory contents
    initial begin
        // Example initialization of specific locations
        mem[0] = 16'hA0A0;
        mem[1] = 16'hB1B1;
        mem[2] = 16'hC2C2;
        mem[3] = 16'hD3D3;
        
        // Uncomment to explicitly initialize remaining locations to zero
        // for (int i = 4; i < MEM_DEPTH; i = i + 1) begin
        //     mem[i] = {MEM_WIDTH{1'b0}};
        // end
    end

    // Continuous read operation
    assign dout = mem[addr];

    /* Design Notes:
     * - Simple continuous assignment for optimal timing
     * - Parameterized memory dimensions for flexibility
     * - Clean initialization with option for full initialization
     * - Wire output declaration for clarity
     */

endmodule