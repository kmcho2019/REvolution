module RAM (
    input clk,
    input rst_n,
    input write_en,
    input [2:0] write_addr,
    input [5:0] write_data,
    input read_en,
    input [2:0] read_addr,
    output reg [5:0] read_data
);

parameter WIDTH = 6;
parameter DEPTH = 8;

reg [5:0] RAM [7:0] = '{default: 6'b0};

always @(*) begin
    if (read_en) begin
        read_data = RAM[read_addr];
    end else begin
        read_data = 6'b0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset logic simplified
    end else if (write_en) begin
        RAM[write_addr] <= write_data;
    end
end

endmodule