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
    
    // Memory array with parameterized dimensions
    reg [WIDTH-1:0] mem [DEPTH-1:0];
    integer i;
    
    // Synchronous write with active-low reset
    always @(posedge clk) begin
        if (!rst_n) begin
            // Clear all memory locations using loop
            for (i = 0; i < DEPTH; i = i + 1) begin
                mem[i] <= {WIDTH{1'b0}};
            end
            read_data <= {WIDTH{1'b0}};
        end
        else begin
            // Write operation
            if (write_en) begin
                mem[write_addr] <= write_data;
            end
            
            // Registered read operation
            if (read_en) begin
                read_data <= mem[read_addr];
            end
        end
    end

endmodule