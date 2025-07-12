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
reg [2:0] write_addr_reg;
reg [5:0] write_data_reg;
reg [2:0] read_addr_reg;
reg clk_gated;

// Clock gating
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_gated <= 1'b0;
    end else begin
        clk_gated <= write_en | read_en;
    end
end

// Pipelined write path
always @(posedge clk_gated or negedge rst_n) begin
    if (!rst_n) begin
        write_addr_reg <= 3'b0;
        write_data_reg <= 6'b0;
    end else if (write_en) begin
        write_addr_reg <= write_addr;
        write_data_reg <= write_data;
    end
end

always @(posedge clk_gated or negedge rst_n) begin
    if (!rst_n) begin
        for (int i = 0; i < DEPTH; i++) begin
            RAM[i] <= 6'b0;
        end
    end else if (write_en) begin
        RAM[write_addr_reg] <= write_data_reg;
    end
end

// Pipelined read path
always @(posedge clk_gated or negedge rst_n) begin
    if (!rst_n) begin
        read_addr_reg <= 3'b0;
        read_data_reg <= 6'b0;
    end else if (read_en) begin
        read_addr_reg <= read_addr;
        read_data_reg <= RAM[read_addr_reg];
    end
end

assign read_data = (read_en) ? read_data_reg : 6'b0;

endmodule