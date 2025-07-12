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
    
    // Write operation with synchronous reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Parallel reset for better timing
            mem[0] <= 0;
            mem[1] <= 0;
            mem[2] <= 0;
            mem[3] <= 0;
            mem[4] <= 0;
            mem[5] <= 0;
            mem[6] <= 0;
            mem[7] <= 0;
        end
        else if (write_en) begin
            mem[write_addr] <= write_data;
        end
    end
    
    // Registered read for better timing
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            read_data <= 0;
        end
        else if (read_en) begin
            read_data <= mem[read_addr];
        end
        // Maintain previous value when not enabled (reduces toggling)
    end

endmodule