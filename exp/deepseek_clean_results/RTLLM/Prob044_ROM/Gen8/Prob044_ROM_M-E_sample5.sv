module ROM (
    input [7:0] addr,
    output reg [15:0] dout
);

    // Base storage for lower addresses (0-15)
    reg [15:0] base_mem [0:15];
    
    // Initialize base memory with specific values
    initial begin
        base_mem[0] = 16'hA0A0;
        base_mem[1] = 16'hB1B1;
        base_mem[2] = 16'hC2C2;
        base_mem[3] = 16'hD3D3;
        // Fill remaining base addresses with incremental pattern
        for (int i = 4; i < 16; i = i + 1) begin
            base_mem[i] = 16'h0000 + i;
        end
    end

    // Pattern generation function for higher addresses
    function [15:0] generate_pattern;
        input [7:0] address;
        begin
            // Custom pattern generation algorithm
            // Example: Fibonacci-like sequence with address as seed
            generate_pattern = {address, 8'h00} ^ {8'h00, address} + address;
        end
    endfunction

    // Continuous read operation with address decoding
    always @(*) begin
        if (addr < 16) begin
            // Read from base storage
            dout = base_mem[addr];
        end else begin
            // Generate pattern for higher addresses
            dout = generate_pattern(addr);
        end
    end

endmodule