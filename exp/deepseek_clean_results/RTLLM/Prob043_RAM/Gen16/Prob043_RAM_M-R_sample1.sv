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
    initial $readmemb("zeros.mem", mem); // Alternative initialization method
    
    // Synchronous write operation
    always @(posedge clk) begin
        if (write_en)
            mem[write_addr] <= write_data;
    end
    
    // Continuous assignment for read path
    assign read_data = read_en ? mem[read_addr] : {WIDTH{1'b0}};

endmodule