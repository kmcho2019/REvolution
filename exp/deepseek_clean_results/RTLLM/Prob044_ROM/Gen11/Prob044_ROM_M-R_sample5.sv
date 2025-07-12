module ROM (
    input [7:0] addr,
    output [15:0] dout
);

    // Memory dimensions
    localparam MEM_DEPTH = 256;
    localparam MEM_WIDTH = 16;
    
    // Memory array declaration
    reg [MEM_WIDTH-1:0] mem [0:MEM_DEPTH-1];

    // Initialize memory contents
    initial begin
        initialize_memory();
    end

    // Continuous read operation using assign
    assign dout = mem[addr];

    // Memory initialization function
    function automatic void initialize_memory();
        // Example initialization of specific locations
        mem[0] = 16'hA0A0;
        mem[1] = 16'hB1B1;
        mem[2] = 16'hC2C2;
        mem[3] = 16'hD3D3;
        
        // Uncomment to explicitly initialize remaining locations to zero
        // for (int i = 4; i < MEM_DEPTH; i = i + 1) begin
        //     mem[i] = {MEM_WIDTH{1'b0}};
        // end
    endfunction

    /* Design Notes:
     * - Using assign statement makes the read path more explicit
     * - Initialization function provides better code organization
     * - localparam makes memory dimensions configurable
     * - Same functionality as original implementation
     */

endmodule