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
reg clk_gated;

// Simplified clock gating for power optimization
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_gated <= 1'b0;
    end else if (write_en || read_en) begin
        clk_gated <= 1'b1;
    end else begin
        clk_gated <= 1'b0;
    end
end

// Simplified sequential block for write operation and reset
always @(posedge clk_gated or negedge rst_n) begin
    if (!rst_n) begin
        // Reset logic simplified
        for (int i = 0; i < DEPTH; i++) begin
            RAM[i] <= 6'b0;
        end
    end else if (write_en) begin
        RAM[write_addr] <= write_data;
    end
end

// Combinatorial logic for read operation
assign read_data = (read_en)? RAM[read_addr] : 6'b0;

endmodule