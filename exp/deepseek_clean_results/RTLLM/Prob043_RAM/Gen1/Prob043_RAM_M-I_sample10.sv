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
    
    // Write operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all memory locations to 0
            for (integer i = 0; i < DEPTH; i = i + 1) begin
                mem[i] <= {WIDTH{1'b0}};
            end
        end
        else if (write_en) begin
            // Write data to specified address
            mem[write_addr] <= write_data;
        end
    end
    
    // Read operation - optimized version
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset read data output
            read_data <= {WIDTH{1'b0}};
        end
        else if (read_en) begin
            // Read data from specified address
            read_data <= mem[read_addr];
        end
        // Removed else branch to save area and power
    end

endmodule