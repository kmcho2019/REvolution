module ROM #(
    parameter ADDR_WIDTH = 8,    // Default 8-bit address
    parameter DATA_WIDTH = 16,   // Default 16-bit data
    parameter MEM_DEPTH = 2**ADDR_WIDTH
) (
    input [ADDR_WIDTH-1:0] addr,
    output reg [DATA_WIDTH-1:0] dout
);

    // Memory array declaration
    reg [DATA_WIDTH-1:0] mem [0:MEM_DEPTH-1];

    // Initialize memory contents
    initial begin
        // Example initialization of specific locations
        mem[0] = 16'hA0A0;
        mem[1] = 16'hB1B1;
        mem[2] = 16'hC2C2;
        mem[3] = 16'hD3D3;
        
        // Initialize remaining locations to zero
        // (Better for power estimation and formal verification)
        for (int i = 4; i < MEM_DEPTH; i = i + 1) begin
            mem[i] = {DATA_WIDTH{1'b0}};
        end
        
        /* Alternative initialization patterns (uncomment as needed):
        // 1. Incrementing pattern
        // for (int i = 0; i < MEM_DEPTH; i = i + 1) begin
        //     mem[i] = i;
        // end
        
        // 2. Custom function-based initialization
        // for (int i = 0; i < MEM_DEPTH; i = i + 1) begin
        //     mem[i] = some_function(i);
        // end
        
        // 3. Read from file initialization
        // $readmemh("rom_init.hex", mem);
        */
    end

    // Continuous read operation (combinational)
    always @(*) begin
        dout = mem[addr];
    end

    /* Design Considerations:
     * 1. Power Optimization:
     *    - Add output register with read-enable to reduce switching
     *    - Consider clock gating if reads are periodic
     *
     * 2. Performance Optimization:
     *    - Register output to improve timing (1-cycle latency)
     *    - Consider pipelining for high-frequency designs
     *
     * 3. Area Optimization:
     *    - For sparse data: Replace array with case statement
     *    - For patterned data: Use LUT generators instead of memory
     *    - Consider memory compression techniques
     *
     * 4. Verification:
     *    - Explicit initialization helps formal verification
     *    - Zero initialization aids power estimation
     *
     * 5. Reusability:
     *    - Parameters allow easy customization
     *    - Multiple initialization options provided
     */

endmodule