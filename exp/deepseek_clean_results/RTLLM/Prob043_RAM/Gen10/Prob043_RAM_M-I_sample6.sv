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
    
    // Reset operation (synchronous)
    integer i;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all memory locations to 0
            for (i = 0; i < DEPTH; i = i + 1) begin
                mem[i] <= {WIDTH{1'b0}};
            end
            read_data <= {WIDTH{1'b0}};
        end
    end
    
    // Write operation (synchronous)
    always @(posedge clk) begin
        if (write_en) begin
            // Write data to specified address
            mem[write_addr] <= write_data;
        end
    end
    
    // Read operation (combinational)
    always @(*) begin
        if (read_en) begin
            read_data = mem[read_addr];
        end
        // else maintain previous value (reduces power consumption)
    end

endmodule