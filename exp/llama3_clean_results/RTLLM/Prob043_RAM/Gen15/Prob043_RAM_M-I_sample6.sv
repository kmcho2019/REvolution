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

// Using a more area-efficient RAM implementation if available
// For demonstration, we'll stick with the reg array but consider dedicated RAM blocks in actual implementation
reg [5:0] RAM [7:0];
reg [5:0] read_data_reg;

// Clock gating logic
reg clk_gated;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_gated <= 1'b0;
    end else begin
        clk_gated <= write_en | read_en;
    end
end

// Combinatorial logic for read operation
assign read_data = (read_en)? RAM[read_addr] : 6'b0;

// Sequential block for write operation and reset
always @(posedge clk_gated or negedge rst_n) begin
    if (!rst_n) begin
        // Reset logic optimized to only reset necessary components
        for (int i = 0; i < DEPTH; i++) begin
            RAM[i] <= 6'b0;
        end
        read_data_reg <= 6'b0;
    end else if (write_en) begin
        // Minimize switching activity by only updating the RAM array when necessary
        if (RAM[write_addr] != write_data) begin
            RAM[write_addr] <= write_data;
        end
    end
end

endmodule