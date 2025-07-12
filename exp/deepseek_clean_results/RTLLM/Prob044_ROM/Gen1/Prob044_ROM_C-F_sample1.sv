module ROM (
    input [7:0] addr,
    output reg [15:0] dout
);

    // Memory array declaration: 256 locations of 16-bit data
    reg [15:0] mem [0:255];

    // Initialize memory contents
    initial begin
        // Predefined pattern for demonstration
        mem[0] = 16'hA0A0;
        mem[1] = 16'hB1B1;
        mem[2] = 16'hC2C2;
        mem[3] = 16'hD3D3;
        
        // Explicitly initialize remaining locations to zero
        // (Better for power estimation and synthesis optimization)
        for (int i = 4; i < 256; i = i + 1) begin
            mem[i] = 16'h0000;
        end
        
        /* Alternative initialization patterns:
        // Option 1: Sequential pattern
        for (int i = 0; i < 256; i = i + 1)
            mem[i] = 16'h0100 + i;
        
        // Option 2: Checkerboard pattern
        for (int i = 0; i < 256; i = i + 1)
            mem[i] = (i % 2) ? 16'hAAAA : 16'h5555;
        */
    end

    // Continuous read operation (combinational)
    always @(*) begin
        dout = mem[addr];
    end

    /* Optional: Registered output version for timing critical designs
    always @(posedge clk) begin
        if (read_en)
            dout_reg <= mem[addr];
    end
    */
endmodule