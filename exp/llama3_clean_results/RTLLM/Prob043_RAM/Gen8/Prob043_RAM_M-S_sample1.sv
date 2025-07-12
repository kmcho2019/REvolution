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

reg [5:0] ram [7:0];
reg [5:0] read_data_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (int i = 0; i < DEPTH; i++) begin
            ram[i] <= 6'b0;
        end
        read_data_reg <= 6'b0;
    end else begin
        if (write_en) begin
            ram[write_addr] <= write_data;
        end
        if (read_en) begin
            read_data_reg <= ram[read_addr];
        end else begin
            read_data_reg <= 6'b0;
        end
    end
end

assign read_data = read_data_reg;

endmodule