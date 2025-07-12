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

// Unified memory for both read and write operations
reg [5:0] mem [7:0];

// Synchronous write operation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (int i = 0; i < DEPTH; i++) begin
            mem[i] <= 6'b0;
        end
    end else if (write_en) begin
        mem[write_addr] <= write_data;
    end
end

// Asynchronous read operation
assign read_data = (read_en)? mem[read_addr] : 6'b0;

endmodule