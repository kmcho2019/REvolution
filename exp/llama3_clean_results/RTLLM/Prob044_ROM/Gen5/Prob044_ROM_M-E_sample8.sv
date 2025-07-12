module Hierarchical_ROM #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 16,
    parameter CACHE_SIZE = 8
)(
    input [ADDR_WIDTH-1:0] addr,
    output reg [DATA_WIDTH-1:0] dout
);

// Cache implementation
reg [DATA_WIDTH-1:0] cache_data [0:CACHE_SIZE-1];
reg [ADDR_WIDTH-1:0] cache_tags [0:CACHE_SIZE-1];
reg [2:0] cache_valid;

// Hierarchical memory structure
reg [DATA_WIDTH-1:0] mem [0:255];

// Control unit signals
reg cache_hit;
reg [ADDR_WIDTH-1:0] cache_addr;

always @(*) begin
    // Check for cache hit
    cache_hit = 0;
    for (int i = 0; i < CACHE_SIZE; i++) begin
        if (cache_valid[i] && cache_tags[i] == addr) begin
            cache_hit = 1;
            cache_addr = i;
            break;
        end
    end
    
    if (cache_hit) begin
        // Cache hit, output cached data
        dout = cache_data[cache_addr];
    end else begin
        // Cache miss, access hierarchical memory
        dout = mem[addr];
        
        // Update cache
        for (int i = 0; i < CACHE_SIZE; i++) begin
            if (!cache_valid[i]) begin
                cache_valid[i] = 1;
                cache_tags[i] = addr;
                cache_data[i] = mem[addr];
                break;
            end
        end
    end
end

initial begin
    // Initialize memory locations 0 through 3 with specific values
    mem[0] = 16'hA0A0;
    mem[1] = 16'hB1B1;
    mem[2] = 16'hC2C2;
    mem[3] = 16'hD3D3;
    // Other locations can be initialized as needed
end

endmodule