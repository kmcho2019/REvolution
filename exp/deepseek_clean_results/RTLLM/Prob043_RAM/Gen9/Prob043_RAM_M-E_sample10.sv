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
    
    // Memory array
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    
    // Pipeline registers
    reg [2:0] write_addr_r, read_addr_r;
    reg [5:0] write_data_r;
    reg write_en_r, read_en_r;
    
    // Write-through detection
    wire same_addr = (write_addr_r == read_addr_r) && write_en_r && read_en_r;
    
    // Pipeline stage 1: Register all inputs
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            write_en_r <= 1'b0;
            read_en_r <= 1'b0;
            write_addr_r <= 3'b0;
            read_addr_r <= 3'b0;
            write_data_r <= {WIDTH{1'b0}};
        end else begin
            write_en_r <= write_en;
            read_en_r <= read_en;
            write_addr_r <= write_addr;
            read_addr_r <= read_addr;
            write_data_r <= write_data;
        end
    end
    
    // Pipeline stage 2: Memory operations
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Lazy reset - only clear when first accessed
            read_data <= {WIDTH{1'b0}};
        end else begin
            // Write operation
            if (write_en_r) begin
                mem[write_addr_r] <= write_data_r;
            end
            
            // Read operation with write-through
            if (read_en_r) begin
                read_data <= same_addr ? write_data_r : mem[read_addr_r];
            end else begin
                read_data <= {WIDTH{1'b0}};
            end
        end
    end
    
    // Initialization (simulation only)
    initial begin
        for (integer i = 0; i < DEPTH; i = i + 1) begin
            mem[i] = {WIDTH{1'b0}};
        end
    end

endmodule