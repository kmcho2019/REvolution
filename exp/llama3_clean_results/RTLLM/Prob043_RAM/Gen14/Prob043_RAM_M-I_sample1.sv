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

reg [5:0] RAM [7:0];
reg [5:0] read_data_reg;

// Simplified clock gating for power optimization
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset condition: Clear all memory locations
        for (int i = 0; i < DEPTH; i++) begin
            RAM[i] <= 6'b0;
        end
        read_data_reg <= 6'b0;
    end else if (write_en) begin
        // Write operation: Update memory at specified address
        RAM[write_addr] <= write_data;
    end
end

// Combinatorial logic for read operation
always @(posedge clk) begin
    if (read_en) begin
        // Read operation: Update read_data_reg with data from specified address
        read_data_reg <= RAM[read_addr];
    end
end

assign read_data = read_data_reg;

endmodule