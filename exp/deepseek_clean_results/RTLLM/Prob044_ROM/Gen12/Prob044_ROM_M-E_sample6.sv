module ROM #(
    parameter WIDTH = 16,        // Data width
    parameter DEPTH = 256,       // Memory depth
    parameter STORED_ENTRIES = 4 // Number of explicitly stored entries
) (
    input [7:0] addr,
    input clk,                   // Optional for registered output
    input reg_out,               // Output register enable
    output reg [WIDTH-1:0] dout
);

    // Stored memory entries
    reg [WIDTH-1:0] stored_mem [0:STORED_ENTRIES-1];

    // Initialize stored values
    initial begin
        stored_mem[0] = 16'hA0A0;
        stored_mem[1] = 16'hB1B1;
        stored_mem[2] = 16'hC2C2;
        stored_mem[3] = 16'hD3D3;
    end

    // Internal combinational output
    wire [WIDTH-1:0] dout_comb;
    
    // Pattern generation logic for addresses beyond stored entries
    assign dout_comb = (addr < STORED_ENTRIES) ? stored_mem[addr] : 
                       {addr, addr} ^ {WIDTH{1'b1}}; // Example pattern: address XOR with all 1s

    // Optional output register
    always @(posedge clk) begin
        if (reg_out) begin
            dout <= dout_comb;
        end
    end

    // Continuous output when not registered
    assign dout = reg_out ? dout : dout_comb;

    /* Design Features:
     * - Reduced memory usage by generating patterns for high addresses
     * - Flexible parameterization for different sizes
     * - Optional output register for timing closure
     * - Deterministic behavior for all addresses
     * - Pattern can be easily modified (e.g., linear, checksum, etc.)
     */
endmodule