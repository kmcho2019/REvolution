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
    
    // Main memory array
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    
    // Write-through cache registers
    reg [2:0] last_write_addr;
    reg [WIDTH-1:0] last_write_data;
    reg cache_valid;
    
    // Gray-coded address registers
    reg [2:0] prev_write_addr_gray;
    reg [2:0] prev_read_addr_gray;
    
    // Memory bank activation flags
    reg [DEPTH-1:0] bank_active;
    
    // Convert binary to gray code
    function [2:0] bin2gray;
        input [2:0] bin;
        begin
            bin2gray = {bin[2], bin[2] ^ bin[1], bin[1] ^ bin[0]};
        end
    endfunction
    
    // Initialize memory and control signals
    integer i;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < DEPTH; i = i + 1) begin
                mem[i] <= {WIDTH{1'b0}};
            end
            last_write_addr <= 3'b0;
            last_write_data <= {WIDTH{1'b0}};
            cache_valid <= 1'b0;
            bank_active <= {DEPTH{1'b0}};
            prev_write_addr_gray <= 3'b0;
            prev_read_addr_gray <= 3'b0;
        end
        else begin
            // Write operation with gray-coded address
            if (write_en) begin
                mem[write_addr] <= write_data;
                last_write_addr <= write_addr;
                last_write_data <= write_data;
                cache_valid <= 1'b1;
                bank_active[write_addr] <= 1'b1;
                prev_write_addr_gray <= bin2gray(write_addr);
            end
            
            // Read operation pipeline stage 1
            if (read_en) begin
                // Check if reading recently written location
                if (cache_valid && (read_addr == last_write_addr)) begin
                    read_data <= last_write_data;
                end
                else if (bank_active[read_addr]) begin
                    read_data <= mem[read_addr];
                end
                else begin
                    read_data <= {WIDTH{1'b0}};
                end
                prev_read_addr_gray <= bin2gray(read_addr);
            end
            else begin
                read_data <= {WIDTH{1'b0}};
            end
            
            // Power-gating control - deactivate unused banks periodically
            if (&prev_write_addr_gray) begin  // Simple periodic trigger
                for (i = 0; i < DEPTH; i = i + 1) begin
                    if (!write_en || (write_addr != i)) begin
                        bank_active[i] <= 1'b0;
                    end
                end
            end
        end
    end

endmodule