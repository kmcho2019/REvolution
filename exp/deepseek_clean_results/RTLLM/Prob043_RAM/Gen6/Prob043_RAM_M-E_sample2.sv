module RAM (
    input clk,
    input rst_n,
    input write_en,
    input [2:0] write_addr,
    input [5:0] write_data,
    input read_en,
    input [2:0] read_addr,
    output reg [5:0] read_data
);

    parameter WIDTH = 6;
    parameter DEPTH = 8;
    
    // Split memory into two banks (4 locations each)
    reg [WIDTH-1:0] bank0 [0:3];
    reg [WIDTH-1:0] bank1 [0:3];
    
    // Write-through cache for last written location
    reg [WIDTH-1:0] write_cache;
    reg [2:0] cache_addr;
    reg cache_valid;
    
    // Bank selection signals
    wire write_bank = write_addr[2];
    wire read_bank = read_addr[2];
    
    integer i;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Initialize both banks and cache
            for (i = 0; i < 4; i = i + 1) begin
                bank0[i] <= {WIDTH{1'b0}};
                bank1[i] <= {WIDTH{1'b0}};
            end
            cache_valid <= 1'b0;
            read_data <= {WIDTH{1'b0}};
        end
        else begin
            // Write operation with bank selection
            if (write_en) begin
                if (write_bank)
                    bank1[write_addr[1:0]] <= write_data;
                else
                    bank0[write_addr[1:0]] <= write_data;
                
                // Update write cache
                write_cache <= write_data;
                cache_addr <= write_addr;
                cache_valid <= 1'b1;
            end
            
            // Read operation with cache check
            if (read_en) begin
                // Check if reading recently written location
                if (cache_valid && (read_addr == cache_addr))
                    read_data <= write_cache;
                else if (read_bank)
                    read_data <= bank1[read_addr[1:0]];
                else
                    read_data <= bank0[read_addr[1:0]];
            end
            else begin
                read_data <= {WIDTH{1'b0}};
            end
        end
    end

endmodule