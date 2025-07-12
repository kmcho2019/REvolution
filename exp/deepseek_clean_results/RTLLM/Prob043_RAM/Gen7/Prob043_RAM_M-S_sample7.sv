module RAM (
    input clk,
    input rst_n,
    input write_en,
    input [2:0] write_addr,
    input [5:0] write_data,
    input [2:0] read_addr,
    output reg [5:0] read_data
);

    parameter WIDTH = 6;
    parameter DEPTH = 8;
    
    // Memory array declaration
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    
    // Initialize memory to zeros (synthesis will handle this)
    initial begin
        for (int i = 0; i < DEPTH; i++) begin
            mem[i] = {WIDTH{1'b0}};
        end
    end
    
    // Single always block for both read and write
    always @(posedge clk) begin
        // Read operation (always enabled)
        read_data <= mem[read_addr];
        
        // Write operation
        if (write_en) begin
            mem[write_addr] <= write_data;
        end
    end

endmodule