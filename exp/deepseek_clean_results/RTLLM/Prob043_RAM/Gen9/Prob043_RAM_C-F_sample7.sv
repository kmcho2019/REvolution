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
    
    // Initialize all memory locations to 0 (simulation only)
    initial begin
        for (int i = 0; i < DEPTH; i++)
            mem[i] = {WIDTH{1'b0}};
    end
    
    // Synchronous write operation
    always @(posedge clk) begin
        if (write_en)
            mem[write_addr] <= write_data;
    end
    
    // Combinational read operation
    always @(*) begin
        read_data = read_en ? mem[read_addr] : 'z; // High-Z when not enabled
    end

endmodule