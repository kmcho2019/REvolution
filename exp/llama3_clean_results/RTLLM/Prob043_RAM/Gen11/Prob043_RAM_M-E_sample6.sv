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

reg [5:0] RAM_bank1 [7:0];
reg [5:0] RAM_bank2 [7:0];

// Synchronous write operation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (int i = 0; i < DEPTH; i++) begin
            RAM_bank1[i] <= 6'b0;
            RAM_bank2[i] <= 6'b0;
        end
    end else if (write_en) begin
        if (write_addr < 4) begin
            RAM_bank1[write_addr] <= write_data;
        end else begin
            RAM_bank2[write_addr - 4] <= write_data;
        end
    end
end

// Asynchronous read operation
reg [5:0] read_data_reg;
always @(*) begin
    if (read_en) begin
        if (read_addr < 4) begin
            read_data_reg = RAM_bank1[read_addr];
        end else begin
            read_data_reg = RAM_bank2[read_addr - 4];
        end
    end else begin
        read_data_reg = 6'b0;
    end
end

assign read_data = read_data_reg;

// Novel clock gating technique
reg clk_gated_bank1;
reg clk_gated_bank2;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_gated_bank1 <= 1'b0;
        clk_gated_bank2 <= 1'b0;
    end else if (write_en && write_addr < 4) begin
        clk_gated_bank1 <= 1'b1;
    end else if (write_en && write_addr >= 4) begin
        clk_gated_bank2 <= 1'b1;
    end else begin
        clk_gated_bank1 <= 1'b0;
        clk_gated_bank2 <= 1'b0;
    end
end

endmodule