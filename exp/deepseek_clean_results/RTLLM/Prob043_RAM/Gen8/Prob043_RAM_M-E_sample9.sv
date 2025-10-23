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
    
    // Packed memory array for better synthesis
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    
    // Registered read address for pipelining
    reg [2:0] read_addr_reg;
    reg read_en_reg;
    
    // Synchronous reset and write operation
    always @(posedge clk) begin
        if (!rst_n) begin
            // Synchronous reset
            for (int i = 0; i < DEPTH; i++) begin
                mem[i] <= {WIDTH{1'b0}};
            end
            read_data <= {WIDTH{1'b0}};
        end
        else begin
            // Write operation with write-through
            if (write_en && write_addr < DEPTH) begin
                mem[write_addr] <= write_data;
                // Write-through: update read data if same address
                if (read_en && (write_addr == read_addr)) begin
                    read_data <= write_data;
                end
            end
            
            // Pipeline stage for read
            read_addr_reg <= read_addr;
            read_en_reg <= read_en;
        end
    end
    
    // Pipelined read operation
    always @(*) begin
        if (read_en_reg) begin
            if (write_en && (write_addr == read_addr_reg)) begin
                // Handle read-during-write to same address
                read_data = write_data;
            end
            else if (read_addr_reg < DEPTH) begin
                read_data = mem[read_addr_reg];
            end
            else begin
                read_data = {WIDTH{1'b0}};
            end
        end
        else begin
            read_data = {WIDTH{1'b0}};
        end
    end

endmodule