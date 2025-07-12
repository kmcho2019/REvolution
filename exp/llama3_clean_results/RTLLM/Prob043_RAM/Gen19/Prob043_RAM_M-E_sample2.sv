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
parameter NUM_BANKS = 2;

reg [5:0] memory_banks [NUM_BANKS-1:0][DEPTH/NUM_BANKS-1:0];
reg [5:0] async_read_buffer;
reg bank_select;

// Bank select logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        bank_select <= 1'b0;
    end else begin
        bank_select <= write_addr[2];
    end
end

// Synchronous write controller
always @(posedge clk) begin
    if (write_en) begin
        if (bank_select) begin
            memory_banks[1][write_addr[1:0]] <= write_data;
        end else begin
            memory_banks[0][write_addr[1:0]] <= write_data;
        end
    end
end

// Asynchronous read buffer
assign async_read_buffer = (read_en)? (bank_select? memory_banks[1][read_addr[1:0]] : memory_banks[0][read_addr[1:0]]) : 6'b0;

// Clock domain crossing circuitry
reg [5:0] read_data_sync;
always @(posedge clk) begin
    read_data_sync <= async_read_buffer;
end

assign read_data = read_data_sync;

endmodule