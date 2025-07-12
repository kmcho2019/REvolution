module RAM (
    input clk,
    input rst_n,
    input write_en,
    input [2:0] write_addr,
    input [5:0] write_data,
    input read_en,
    input [2:0] read_addr,
    output reg [5:0] read_data,
    output parity_error
);

    parameter WIDTH = 6;
    parameter DEPTH = 8;
    parameter PIPELINED = 1;  // Set to 1 for registered outputs
    
    // Memory array with parity (7 bits total: 6 data + 1 parity)
    reg [WIDTH:0] mem_bank0 [0:DEPTH/2-1];
    reg [WIDTH:0] mem_bank1 [0:DEPTH/2-1];
    
    // Write-through cache
    reg [WIDTH:0] cache [0:1];  // 2-entry cache
    reg [2:0] cache_addr [0:1];
    reg cache_valid [0:1];
    
    // Gray-coded addresses for power optimization
    reg [2:0] prev_write_addr, prev_read_addr;
    wire [2:0] gray_write_addr = write_addr ^ (write_addr >> 1);
    wire [2:0] gray_read_addr = read_addr ^ (read_addr >> 1);
    
    // Parity generation
    wire write_parity = ^write_data;
    wire [5:0] cached_data [0:1];
    wire cached_parity [0:1];
    
    // Initialize memory and cache
    integer i;
    initial begin
        for (i = 0; i < DEPTH/2; i = i + 1) begin
            mem_bank0[i] = {(WIDTH+1){1'b0}};
            mem_bank1[i] = {(WIDTH+1){1'b0}};
        end
        for (i = 0; i < 2; i = i + 1) begin
            cache[i] = {(WIDTH+1){1'b0}};
            cache_addr[i] = 3'b0;
            cache_valid[i] = 1'b0;
        end
    end
    
    // Write operation - banked memory with parity
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            prev_write_addr <= 3'b0;
        end else if (write_en) begin
            // Store in appropriate bank based on LSB
            if (write_addr[0]) begin
                mem_bank1[write_addr[2:1]] <= {write_parity, write_data};
            end else begin
                mem_bank0[write_addr[2:1]] <= {write_parity, write_data};
            end
            
            // Update write-through cache
            if (cache_addr[0] == write_addr) begin
                cache[0] <= {write_parity, write_data};
            end
            if (cache_addr[1] == write_addr) begin
                cache[1] <= {write_parity, write_data};
            end
            
            prev_write_addr <= gray_write_addr;
        end
    end
    
    // Read operation - cache first, then memory
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            read_data <= {WIDTH{1'b0}};
            prev_read_addr <= 3'b0;
        end else if (read_en) begin
            // Check cache first
            if (cache_valid[0] && cache_addr[0] == read_addr) begin
                {cached_parity[0], cached_data[0]} <= cache[0];
                read_data <= cached_data[0];
            end else if (cache_valid[1] && cache_addr[1] == read_addr) begin
                {cached_parity[1], cached_data[1]} <= cache[1];
                read_data <= cached_data[1];
            end else begin
                // Read from appropriate memory bank
                if (read_addr[0]) begin
                    {cached_parity[1], cached_data[1]} <= mem_bank1[read_addr[2:1]];
                    read_data <= cached_data[1];
                    // Update cache (LRU style)
                    cache[0] <= cache[1];
                    cache_addr[0] <= cache_addr[1];
                    cache_valid[0] <= cache_valid[1];
                    cache[1] <= mem_bank1[read_addr[2:1]];
                    cache_addr[1] <= read_addr;
                    cache_valid[1] <= 1'b1;
                end else begin
                    {cached_parity[0], cached_data[0]} <= mem_bank0[read_addr[2:1]];
                    read_data <= cached_data[0];
                    // Update cache (LRU style)
                    cache[1] <= cache[0];
                    cache_addr[1] <= cache_addr[0];
                    cache_valid[1] <= cache_valid[0];
                    cache[0] <= mem_bank0[read_addr[2:1]];
                    cache_addr[0] <= read_addr;
                    cache_valid[0] <= 1'b1;
                end
            end
            
            prev_read_addr <= gray_read_addr;
        end
    end
    
    // Parity error detection
    assign parity_error = (read_en && ((cache_valid[0] && cache_addr[0] == read_addr && (^cache[0])) ||
                         (cache_valid[1] && cache_addr[1] == read_addr && (^cache[1])) ||
                         (read_addr[0] && (^mem_bank1[read_addr[2:1]])) ||
                         (!read_addr[0] && (^mem_bank0[read_addr[2:1]])));

endmodule