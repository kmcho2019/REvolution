module RAM (
    input clk,
    input write_en,
    input [2:0] write_addr,  // Explicit 3-bit address for DEPTH=8
    input [5:0] write_data,  // Explicit 6-bit width
    input read_en,
    input [2:0] read_addr,
    output [5:0] read_data
);

    // Memory array declaration
    reg [5:0] mem [0:7];  // Fixed size for DEPTH=8
    
    // Initialize all memory locations to 0
    integer i;
    initial begin
        for (i = 0; i < 8; i = i + 1)
            mem[i] = 6'b000000;
    end
    
    // Continuous assignment for read path
    assign read_data = read_en ? mem[read_addr] : 6'b000000;
    
    // Synchronous write operation
    always @(posedge clk) begin
        if (write_en)
            mem[write_addr] <= write_data;
    end

endmodule