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

// Asynchronous memory for read operation
reg [5:0] async_mem [7:0];

// Synchronous register file for write operation
reg [5:0] reg_file [7:0];

// Clock-gating logic for power management
reg clk_gated;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_gated <= 1'b0;
    end else begin
        clk_gated <= write_en;
    end
end

// Synchronous write operation
always @(posedge clk_gated or negedge rst_n) begin
    if (!rst_n) begin
        for (int i = 0; i < DEPTH; i++) begin
            reg_file[i] <= 6'b0;
        end
    end else if (write_en) begin
        reg_file[write_addr] <= write_data;
        async_mem[write_addr] <= write_data;
    end
end

// Asynchronous read operation
assign read_data = (read_en)? async_mem[read_addr] : 6'b0;

endmodule