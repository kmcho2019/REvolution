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
    
    // Memory array with synchronous reset
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    
    // Write operation (synchronous)
    always @(posedge clk) begin
        if (write_en) begin
            mem[write_addr] <= write_data;
        end
    end
    
    // Read operation (asynchronous)
    assign read_data = mem[read_addr];

endmodule