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

// Synchronous write controller
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all memory locations
        for (int i = 0; i < DEPTH; i++) begin
            RAM[i] <= 6'b0;
        end
    end else if (write_en) begin
        // Write data to the specified address
        RAM[write_addr] <= write_data;
    end
end

// Asynchronous read controller
assign read_data = (read_en)? RAM[read_addr] : 6'b0;

// Power reduction technique: clock gating
reg clk_gated;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_gated <= 1'b0;
    end else begin
        clk_gated <= write_en;
    end
end

// Asynchronous memory cells
// (Note: This is a conceptual representation and may require additional implementation details)
reg [5:0] async_ram [7:0];
always @(*) begin
    async_ram[read_addr] = RAM[read_addr];
end

endmodule