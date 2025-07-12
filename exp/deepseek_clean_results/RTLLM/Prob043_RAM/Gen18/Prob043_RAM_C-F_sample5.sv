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
    integer i;
    
    // Synchronous write with reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Initialize all memory locations to 0
            for (i = 0; i < DEPTH; i = i + 1)
                mem[i] <= {WIDTH{1'b0}};
        end
        else if (write_en) begin
            // Write to specified address
            mem[write_addr] <= write_data;
        end
    end
    
    // Combinational read with enable control
    always @(*) begin
        if (read_en)
            read_data = mem[read_addr];
        // Else maintain previous value (power optimization)
    end

endmodule