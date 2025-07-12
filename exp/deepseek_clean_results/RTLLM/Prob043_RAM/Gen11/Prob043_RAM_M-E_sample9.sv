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
    
    // Memory array declaration
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    
    // Internal signals
    reg [WIDTH-1:0] read_data_next;
    reg write_valid;
    reg [2:0] write_addr_reg;
    reg [5:0] write_data_reg;
    
    // Memory initialization and synchronous reset
    integer i;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all memory locations to 0
            for (i = 0; i < DEPTH; i = i + 1) begin
                mem[i] <= {WIDTH{1'b0}};
            end
            write_valid <= 1'b0;
        end
        else begin
            // Write operation with address range check
            if (write_en && (write_addr < DEPTH)) begin
                mem[write_addr] <= write_data;
            end
            // Register write signals for write-through detection
            write_valid <= write_en;
            write_addr_reg <= write_addr;
            write_data_reg <= write_data;
        end
    end
    
    // Read operation with pipeline stage
    always @(*) begin
        if (read_en && (read_addr < DEPTH)) begin
            // Write-through detection
            if (write_valid && (write_addr_reg == read_addr)) begin
                read_data_next = write_data_reg;
            end
            else begin
                read_data_next = mem[read_addr];
            end
        end
        else begin
            read_data_next = {WIDTH{1'b0}};
        end
    end
    
    // Output register for read data
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            read_data <= {WIDTH{1'b0}};
        end
        else begin
            read_data <= read_data_next;
        end
    end

endmodule