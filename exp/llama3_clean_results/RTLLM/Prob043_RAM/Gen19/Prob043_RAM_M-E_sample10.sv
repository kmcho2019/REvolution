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
reg [2:0] write_addr_async;
reg [5:0] write_data_async;
reg write_en_async;

// Asynchronous write block
always @(posedge write_en or negedge rst_n) begin
    if (!rst_n) begin
        write_addr_async <= 3'b0;
        write_data_async <= 6'b0;
        write_en_async <= 1'b0;
    end else if (write_en) begin
        write_addr_async <= write_addr;
        write_data_async <= write_data;
        write_en_async <= 1'b1;
    end else begin
        write_addr_async <= write_addr_async;
        write_data_async <= write_data_async;
        write_en_async <= 1'b0;
    end
end

// Clock domain crossing (CDC) module
reg [5:0] write_data_cdc;
reg [2:0] write_addr_cdc;
reg write_en_cdc;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        write_data_cdc <= 6'b0;
        write_addr_cdc <= 3'b0;
        write_en_cdc <= 1'b0;
    end else begin
        write_data_cdc <= write_data_async;
        write_addr_cdc <= write_addr_async;
        write_en_cdc <= write_en_async;
    end
end

// Synchronous read block
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (int i = 0; i < DEPTH; i++) begin
            RAM[i] <= 6'b0;
        end
    end else if (write_en_cdc) begin
        RAM[write_addr_cdc] <= write_data_cdc;
    end
end

// Read operation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        read_data <= 6'b0;
    end else if (read_en) begin
        read_data <= RAM[read_addr];
    end else begin
        read_data <= 6'b0;
    end
end

endmodule