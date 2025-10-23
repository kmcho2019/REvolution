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

// Asynchronous memory blocks
reg [5:0] mem_block1 [DEPTH/2-1:0];
reg [5:0] mem_block2 [DEPTH/2-1:0];

// Synchronous control unit
reg [1:0] block_select;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        block_select <= 2'b0;
    end else if (write_en) begin
        block_select <= write_addr[2];
    end
end

// Write operation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (int i = 0; i < DEPTH/2; i++) begin
            mem_block1[i] <= 6'b0;
            mem_block2[i] <= 6'b0;
        end
    end else if (write_en) begin
        if (block_select == 2'b0) begin
            mem_block1[write_addr[1:0]] <= write_data;
        end else begin
            mem_block2[write_addr[1:0]] <= write_data;
        end
    end
end

// Read operation
reg [5:0] read_data_temp;
always @(*) begin
    if (read_en) begin
        if (block_select == 2'b0) begin
            read_data_temp = mem_block1[read_addr[1:0]];
        end else begin
            read_data_temp = mem_block2[read_addr[1:0]];
        end
    end else begin
        read_data_temp = 6'b0;
    end
end

assign read_data = read_data_temp;

endmodule