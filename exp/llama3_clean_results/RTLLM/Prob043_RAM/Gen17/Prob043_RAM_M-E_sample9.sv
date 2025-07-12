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
parameter NUM_BLOCKS = 2;

reg [5:0] memory_blocks [NUM_BLOCKS-1:0][DEPTH/NUM_BLOCKS-1:0];

// Address decoder
reg [1:0] block_addr;
always @(write_addr or read_addr) begin
    block_addr = write_addr[2:1];
end

// Write operation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (int i = 0; i < NUM_BLOCKS; i++) begin
            for (int j = 0; j < DEPTH/NUM_BLOCKS; j++) begin
                memory_blocks[i][j] <= 6'b0;
            end
        end
    end else if (write_en) begin
        memory_blocks[block_addr][write_addr[1:0]] <= write_data;
    end
end

// Read operation
reg [5:0] read_data_temp;
always @(*) begin
    if (read_en) begin
        read_data_temp = memory_blocks[block_addr][read_addr[1:0]];
    end else begin
        read_data_temp = 6'b0;
    end
end

assign read_data = read_data_temp;

endmodule