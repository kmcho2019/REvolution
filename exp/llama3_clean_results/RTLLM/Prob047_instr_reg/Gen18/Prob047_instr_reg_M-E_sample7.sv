module instr_reg(
    input clk,         // Clock signal for synchronization
    input rst,         // Active low reset signal
    input [1:0] fetch, // Control signal indicating the source of the instruction
    input [7:0] data,  // 8-bit data input representing the instruction to be fetched

    output [2:0] ins,  // High 3 bits of the instruction, indicating the opcode or operation
    output [4:0] ad1,  // Low 5 bits of the instruction, representing the register address
    output [7:0] ad2   // The full 8-bit data from the second source
);

// Define the size of the instruction cache
parameter ICACHE_SIZE = 4;

// Instruction cache and main register
reg [7:0] icache [ICACHE_SIZE-1:0];
reg [7:0] mreg;

// Signals to manage cache access and updates
reg [ICACHE_SIZE-1:0] cache_hit;
reg [ICACHE_SIZE-1:0] cache_miss;

// Logic to determine cache hits and misses
always @(posedge clk) begin
    if (~rst) begin
        // Reset all registers and signals
        icache <= '{default: 8'd0};
        mreg <= 8'd0;
        cache_hit <= '{default: 1'b0};
        cache_miss <= '{default: 1'b0};
    end else begin
        // Check for cache hits and misses
        for (int i = 0; i < ICACHE_SIZE; i++) begin
            if (icache[i] == data) begin
                cache_hit[i] <= 1'b1;
            end else begin
                cache_hit[i] <= 1'b0;
            end
            if (icache[i] != data && cache_hit[i] == 1'b0) begin
                cache_miss[i] <= 1'b1;
            end else begin
                cache_miss[i] <= 1'b0;
            end
        end
        
        // Update the main register based on the fetch signal
        if (fetch == 2'b01) begin
            mreg <= data;
        end
        
        // Update the cache on cache misses
        for (int i = 0; i < ICACHE_SIZE; i++) begin
            if (cache_miss[i] == 1'b1) begin
                icache[i] <= data;
            end
        end
    end
end

// Output logic
assign ins = (|cache_hit) ? icache[0][7:5] : mreg[7:5];  // High 3 bits of the instruction
assign ad1 = (|cache_hit) ? icache[0][4:0] : mreg[4:0];  // Low 5 bits of the instruction
assign ad2 = (fetch == 2'b10) ? data : 8'd0;  // Simplified logic for ad2

endmodule