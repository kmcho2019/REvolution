module instr_reg (
    input clk,
    input rst,
    input [1:0] fetch,
    input [7:0] data,
    output [2:0] ins,
    output [4:0] ad1,
    output [7:0] ad2
);

// Parameters for the cache
parameter CACHE_SIZE = 8;
parameter TAG_SIZE = 8;

// Type definitions for cache entries and tags
typedef struct {
    reg [7:0] data;
    reg [TAG_SIZE-1:0] tag;
    reg valid;
} cache_entry;

// Cache array
cache_entry cache[CACHE_SIZE-1:0];

// LRU counter
reg [CACHE_SIZE-1:0] lru_counter;

// Current LRU index
reg [CACHE_SIZE-1:0] lru_index;

// Internal signals for cache management
reg cache_hit;
reg [CACHE_SIZE-1:0] cache_hit_index;

// Instruction registers
reg [7:0] ins_p1;
reg [7:0] ins_p2;

// Cache management logic
always @(posedge clk or negedge rst) begin
    if (~rst) begin
        // Reset cache and LRU counter
        for (int i = 0; i < CACHE_SIZE; i++) begin
            cache[i].valid <= 1'b0;
        end
        lru_counter <= {CACHE_SIZE{1'b0}};
        lru_index <= {CACHE_SIZE{1'b0}};
    end else begin
        // Update LRU counter
        lru_counter <= lru_counter + 1;

        // Check cache
        cache_hit <= 1'b0;
        cache_hit_index <= {CACHE_SIZE{1'b0}};
        for (int i = 0; i < CACHE_SIZE; i++) begin
            if (cache[i].valid && cache[i].tag == data[TAG_SIZE-1:0]) begin
                cache_hit <= 1'b1;
                cache_hit_index <= i;
                // Update LRU counter for hit entry
                lru_counter[i] <= 1'b1;
            end
        end

        // Fetch logic
        if (fetch == 2'b01) begin
            if (cache_hit) begin
                // Cache hit, use cached data
                ins_p1 <= cache[cache_hit_index].data;
            end else begin
                // Cache miss, fetch from data input
                ins_p1 <= data;
                // Update cache
                for (int i = 0; i < CACHE_SIZE; i++) begin
                    if (~cache[i].valid) begin
                        // Empty slot found, fill it
                        cache[i].data <= data;
                        cache[i].tag <= data[TAG_SIZE-1:0];
                        cache[i].valid <= 1'b1;
                        lru_counter[i] <= 1'b1;
                        break;
                    end
                end
            end
        end else if (fetch == 2'b10) begin
            ins_p2 <= data;
        end
    end
end

// Output derivation logic
assign ins = ins_p1[7:5];
assign ad1 = ins_p1[4:0];
assign ad2 = ins_p2;

endmodule