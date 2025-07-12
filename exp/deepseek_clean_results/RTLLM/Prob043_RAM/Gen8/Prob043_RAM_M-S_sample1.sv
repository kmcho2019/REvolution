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
    
    // Initialize memory to zero
    integer i;
    initial begin
        for (i = 0; i < DEPTH; i = i + 1)
            mem[i] = {WIDTH{1'b0}};
    end
    
    // Synchronous read operation
    always @(posedge clk) begin
        read_data <= mem[read_addr];
    end
    
    // Synchronous write operation
    always @(posedge clk) begin
        if (write_en)
            mem[write_addr] <= write_data;
    end

endmodule