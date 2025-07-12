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
reg [5:0] shadow_reg;
reg [2:0] shadow_addr;

// Combinatorial logic for write operation
always @(write_en or write_addr or write_data) begin
    if (write_en) begin
        RAM[write_addr] = write_data;
        shadow_reg = write_data;
        shadow_addr = write_addr;
    end
end

// Sequential block for read operation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        read_data <= 6'b0;
    end else if (read_en) begin
        if (read_addr == shadow_addr) begin
            read_data <= shadow_reg;
        end else begin
            read_data <= RAM[read_addr];
        end
    end
end

// Clock gating for power optimization
reg clk_gated;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_gated <= 1'b0;
    end else begin
        clk_gated <= write_en | read_en;
    end
end

// Low-power memory cells
reg [5:0] low_power_ram [7:0];
always @(posedge clk_gated) begin
    if (write_en) begin
        low_power_ram[write_addr] <= write_data;
    end
end

// Content-Addressable Memory (CAM)
reg [5:0] cam_ram [7:0];
reg [2:0] cam_addr [7:0];
always @(posedge clk_gated) begin
    if (write_en) begin
        cam_ram[write_addr] <= write_data;
        cam_addr[write_addr] <= write_addr;
    end
end

// Pipelined architecture
reg [5:0] pipeline_reg1;
reg [5:0] pipeline_reg2;
always @(posedge clk_gated) begin
    pipeline_reg1 <= read_data;
    pipeline_reg2 <= pipeline_reg1;
end

endmodule