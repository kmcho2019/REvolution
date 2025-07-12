module HDP_RAM (
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

// Synchronous memory array for writes
reg [5:0] sync_RAM [7:0];

// Asynchronous memory array for reads
reg [5:0] async_RAM [7:0];

// Synchronization signal to update async_RAM during writes
reg sync_update;

// Initialize both memory arrays to zero on reset
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (int i = 0; i < DEPTH; i++) begin
            sync_RAM[i] <= 6'b0;
            async_RAM[i] <= 6'b0;
        end
        sync_update <= 1'b0;
    end else if (write_en) begin
        // Perform synchronous write operation
        sync_RAM[write_addr] <= write_data;
        // Update async_RAM and set sync_update signal
        async_RAM[write_addr] <= write_data;
        sync_update <= 1'b1;
    end else begin
        sync_update <= 1'b0;
    end
end

// Asynchronous read operation
always @(*) begin
    if (read_en) begin
        // Fetch data from async_RAM
        read_data = async_RAM[read_addr];
    end else begin
        read_data = 6'b0;
    end
end

endmodule