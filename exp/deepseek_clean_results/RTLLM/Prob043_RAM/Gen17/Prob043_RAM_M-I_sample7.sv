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
    
    // Synchronous write and reset operation
    integer i;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Synchronous reset
            for (i = 0; i < DEPTH; i = i + 1)
                mem[i] <= {WIDTH{1'b0}};
            read_data <= {WIDTH{1'b0}};
        end
        else begin
            // Write operation
            if (write_en)
                mem[write_addr] <= write_data;
            
            // Registered read operation
            if (read_en)
                read_data <= mem[read_addr];
            // else maintain previous value (power optimization)
        end
    end

endmodule