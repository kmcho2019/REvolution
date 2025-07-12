module ROM (
    input [7:0] addr,
    output reg [15:0] dout
);

    // Sparse memory storage for explicit values
    reg [15:0] mem [0:255];
    reg [255:0] valid_addr = 0;  // Bitmask for initialized addresses

    // Default fill pattern (parameterizable)
    parameter DEFAULT_FILL = 16'h0000;
    
    // Initialize specific memory locations
    initial begin
        store_value(0, 16'hA0A0);
        store_value(1, 16'hB1B1);
        store_value(2, 16'hC2C2);
        store_value(3, 16'hD3D3);
    end

    // Helper function to store values and mark valid addresses
    function automatic void store_value(input [7:0] a, input [15:0] v);
        mem[a] = v;
        valid_addr[a] = 1'b1;
    endfunction

    // Function to check if address has explicit data
    function automatic is_initialized(input [7:0] a);
        return valid_addr[a];
    endfunction

    // Pattern generation for unimplemented addresses
    function automatic [15:0] generate_pattern(input [7:0] a);
        // Simple linear pattern for demonstration
        // Could be replaced with any mathematical function
        return DEFAULT_FILL + a;
    endfunction

    // Read logic with pattern generation fallback
    always @(*) begin
        dout = is_initialized(addr) ? mem[addr] : generate_pattern(addr);
    end

endmodule