module DualPortRAM_Hybrid (
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

// Synchronous write array
reg [5:0] sync_write_ram [7:0];

// Asynchronous read array
reg [5:0] async_read_ram [7:0];

// Power-gating signals
reg sync_write_pg, async_read_pg;

// Address decoding signals
reg [2:0] write_addr_dec, read_addr_dec;

// Clock-gating logic for synchronous write array
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sync_write_ram <= '{default: 6'b0};
        sync_write_pg <= 1'b0;
    end else if (write_en) begin
        sync_write_ram[write_addr] <= write_data;
        sync_write_pg <= 1'b1;
    end else begin
        sync_write_pg <= 1'b0;
    end
end

// Combinational logic for asynchronous read array
always @(*) begin
    if (read_en) begin
        read_data <= async_read_ram[read_addr];
        async_read_pg <= 1'b1;
    end else begin
        read_data <= 6'b0;
        async_read_pg <= 1'b0;
    end
end

// Address decoding logic
always @(*) begin
    write_addr_dec <= write_addr;
    read_addr_dec <= read_addr;
end

// Power-gating logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        async_read_ram <= '{default: 6'b0};
    end else if (async_read_pg) begin
        async_read_ram[read_addr_dec] <= sync_write_ram[read_addr_dec];
    end
end

endmodule