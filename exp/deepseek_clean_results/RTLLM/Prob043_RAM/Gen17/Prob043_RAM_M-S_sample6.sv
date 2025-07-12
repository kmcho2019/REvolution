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
    
    // Memory array
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Write operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all memory locations
            for (integer i = 0; i < DEPTH; i = i + 1)
                mem[i] <= 0;
        end
        else if (write_en) begin
            mem[write_addr] <= write_data;
        end
    end

    // Read operation (combinational)
    always @(*) begin
        if (read_en)
            read_data = mem[read_addr];
        else
            read_data = 0;
    end

endmodule