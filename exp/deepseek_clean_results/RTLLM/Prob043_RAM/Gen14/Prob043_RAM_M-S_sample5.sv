module RAM (
    input clk,
    input rst_n,
    input write_en,
    input [2:0] write_addr,
    input [5:0] write_data,
    input [2:0] read_addr,
    output reg [5:0] read_data
);

    parameter WIDTH = 6;
    parameter DEPTH = 8;
    
    // Memory array declaration
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    
    // Initialize memory to zeros
    integer i;
    initial begin
        for (i = 0; i < DEPTH; i = i + 1)
            mem[i] = {WIDTH{1'b0}};
    end
    
    // Synchronous read and write operations
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            read_data <= {WIDTH{1'b0}};
            // Memory initialization handled by initial block
        end
        else begin
            // Always update read_data with current address
            read_data <= mem[read_addr];
            
            // Conditional write operation
            if (write_en)
                mem[write_addr] <= write_data;
        end
    end

endmodule