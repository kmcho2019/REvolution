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
parameter NUM_RAM_BLOCKS = 4;

reg [5:0] ram_block [NUM_RAM_BLOCKS-1:0][DEPTH/NUM_RAM_BLOCKS-1:0];
reg [5:0] read_data_reg;
reg [1:0] ram_block_select;

// Clock gating
reg clk_gated;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_gated <= 1'b0;
    end else begin
        clk_gated <= write_en | read_en;
    end
end

// Address mapping
always @(*) begin
    ram_block_select = write_addr[2:1];
end

// Write operation
always @(posedge clk_gated or negedge rst_n) begin
    if (!rst_n) begin
        // Reset logic
        for (int i = 0; i < NUM_RAM_BLOCKS; i++) begin
            for (int j = 0; j < DEPTH/NUM_RAM_BLOCKS; j++) begin
                ram_block[i][j] <= 6'b0;
            end
        end
    end else if (write_en) begin
        ram_block[ram_block_select][write_addr[0]] <= write_data;
    end
end

// Read operation
always @(*) begin
    if (read_en) begin
        read_data_reg = ram_block[read_addr[2:1]][read_addr[0]];
    end else begin
        read_data_reg = 6'b0;
    end
end

assign read_data = read_data_reg;

endmodule