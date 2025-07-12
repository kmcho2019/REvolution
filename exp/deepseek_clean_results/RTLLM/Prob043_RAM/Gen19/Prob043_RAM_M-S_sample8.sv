module RAM (
    input clk,
    input write_en,
    input [2:0] write_addr,
    input [5:0] write_data,
    input read_en,
    input [2:0] read_addr,
    output reg [5:0] read_data
);

    parameter WIDTH = 6;
    parameter DEPTH = 8;
    
    // Memory array with initialization
    reg [WIDTH-1:0] mem [0:DEPTH-1] = '{default:0};
    
    // Synchronous write
    always @(posedge clk) begin
        if (write_en)
            mem[write_addr] <= write_data;
    end
    
    // Combinational read
    always @(*) begin
        read_data = read_en ? mem[read_addr] : 'x;
    end

endmodule