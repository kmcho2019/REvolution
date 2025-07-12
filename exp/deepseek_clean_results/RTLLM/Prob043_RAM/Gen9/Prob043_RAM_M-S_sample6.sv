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
    
    // Memory array declaration with initialization
    reg [WIDTH-1:0] mem [0:DEPTH-1] = '{default:0};
    
    // Combined read/write operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            read_data <= {WIDTH{1'b0}};
        end
        else begin
            if (write_en)
                mem[write_addr] <= write_data;
            
            if (read_en)
                read_data <= mem[read_addr];
        end
    end

endmodule