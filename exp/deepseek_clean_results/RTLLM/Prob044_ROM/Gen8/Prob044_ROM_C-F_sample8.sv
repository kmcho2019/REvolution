module ROM #(
    parameter ADDR_WIDTH = 8,       // Default 8-bit address
    parameter DATA_WIDTH = 16,      // Default 16-bit data
    parameter DEPTH = 2**ADDR_WIDTH // Default 256 entries
)(
    input [ADDR_WIDTH-1:0] addr,
    input enable,                   // Output enable for power optimization
    output reg [DATA_WIDTH-1:0] dout
);

    // Memory array declaration with parameterized size
    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    // Initialize specific memory locations
    initial begin
        mem[0] = 16'hA0A0;
        mem[1] = 16'hB1B1;
        mem[2] = 16'hC2C2;
        mem[3] = 16'hD3D3;
        // Other locations remain at default 0
    end

    // Power-optimized read operation with output enable
    always @(*) begin
        if (enable)
            dout = mem[addr];
        else
            dout = {DATA_WIDTH{1'bz}}; // High-Z when disabled
    end

endmodule