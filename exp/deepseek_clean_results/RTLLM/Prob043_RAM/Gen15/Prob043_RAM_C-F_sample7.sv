module RAM (
    input clk,
    input rst_n,
    input write_en,
    input [2:0] write_addr,
    input [5:0] write_data,
    input read_en,
    input [2:0] read_addr,
    output [5:0] read_data
);

    parameter WIDTH = 6;
    parameter DEPTH = 8;
    
    // Memory array declaration and initialization
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
    
    // Combinational read with enable control
    assign read_data = read_en ? mem[read_addr] : {WIDTH{1'b0}};

endmodule