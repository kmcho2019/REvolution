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
    
    // Memory array with initialization
    reg [WIDTH-1:0] mem [0:DEPTH-1] = '{default:0};
    
    // Write operation with synchronous reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Initialization handled by declaration
        end
        else if (write_en) begin
            mem[write_addr] <= write_data;
        end
    end
    
    // Continuous read (combinational)
    assign read_data = mem[read_addr];

endmodule