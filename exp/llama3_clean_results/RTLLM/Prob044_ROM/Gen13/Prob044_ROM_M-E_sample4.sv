// ROM with cache module
module ROM_Cache #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 16,
    parameter CACHE_SIZE = 16
)(
    input [ADDR_WIDTH-1:0] addr,
    input enable_cache,
    output reg [DATA_WIDTH-1:0] dout
);

// Calculate the memory size based on the address width
localparam MEM_SIZE = 2**ADDR_WIDTH;

// Declare the main memory array
reg [DATA_WIDTH-1:0] mem [0:MEM_SIZE-1];

// Declare the cache memory array
reg [DATA_WIDTH-1:0] cache [0:CACHE_SIZE-1];

// Declare the cache tag array
reg [ADDR_WIDTH-1:0] cache_tag [0:CACHE_SIZE-1];

// Declare the LRU counter array
reg [7:0] lru_counter [0:CACHE_SIZE-1];

// Initial block to pre-load the ROM with fixed data
initial begin
    // Initialize memory locations 0 through 3 with specific values
    mem[0] = 16'hA0A0;
    mem[1] = 16'hB1B1;
    mem[2] = 16'hC2C2;
    mem[3] = 16'hD3D3;
    // Other locations can be initialized as needed
end

// Always block to manage the cache and output the data
always @(*) begin
    if (enable_cache) begin
        // Check if the requested address is in the cache
        reg [7:0] cache_hit;
        reg [7:0] cache_index;
        for (int i = 0; i < CACHE_SIZE; i++) begin
            if (cache_tag[i] == addr) begin
                cache_hit = 1;
                cache_index = i;
                break;
            end
        end
        
        if (cache_hit) begin
            // Cache hit, return the cached data
            dout = cache[cache_index];
            // Update the LRU counter
            for (int i = 0; i < CACHE_SIZE; i++) begin
                if (i != cache_index) begin
                    lru_counter[i] = lru_counter[i] + 1;
                end
            end
            lru_counter[cache_index] = 0;
        end else begin
            // Cache miss, retrieve the data from the main memory
            dout = mem[addr];
            // Update the cache with the newly accessed data
            reg [7:0] lru_index;
            reg [7:0] max_lru;
            max_lru = lru_counter[0];
            lru_index = 0;
            for (int i = 1; i < CACHE_SIZE; i++) begin
                if (lru_counter[i] > max_lru) begin
                    max_lru = lru_counter[i];
                    lru_index = i;
                end
            end
            cache[lru_index] = mem[addr];
            cache_tag[lru_index] = addr;
            // Update the LRU counter
            for (int i = 0; i < CACHE_SIZE; i++) begin
                if (i != lru_index) begin
                    lru_counter[i] = lru_counter[i] + 1;
                end
            end
            lru_counter[lru_index] = 0;
        end
    end else begin
        // Cache disabled, directly access the main memory
        dout = mem[addr];
    end
end

endmodule