module RAM (
    input clk,
    input write_en,
    input [2:0] write_addr,
    input [5:0] write_data,
    input [2:0] read_addr,
    output [5:0] read_data
);

    parameter WIDTH = 6;
    parameter DEPTH = 8;
    
    // Memory array declaration
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    
    // Initialize all memory locations to 0
    integer i;
    initial begin
        for (i = 0; i < DEPTH; i = i + 1)
            mem[i] = {WIDTH{1'b0}};
    end
    
    // Synchronous write operation
    always @(posedge clk) begin
        if (write_en)
            mem[write_addr] <= write_data;
    end
    
    // Combinational read (always enabled)
    assign read_data = mem[read_addr];

endmodule