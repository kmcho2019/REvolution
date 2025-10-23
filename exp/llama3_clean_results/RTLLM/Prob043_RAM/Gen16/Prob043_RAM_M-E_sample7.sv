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

// Asynchronous write controller
always @(write_en or write_addr or write_data) begin
    if (write_en) begin
        RAM[write_addr] <= write_data;
    end
end

// Synchronous read controller
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        read_data <= 6'b0;
    end else if (read_en) begin
        read_data <= RAM[read_addr];
    end
end

endmodule