module RAM #(
    parameter WIDTH = 6,
    parameter DEPTH = 8
) (
    input clk,
    input rst_n,
    input write_en,
    input [2:0] write_addr,
    input [WIDTH-1:0] write_data,
    input read_en,
    input [2:0] read_addr,
    output [WIDTH-1:0] read_data
);

reg [WIDTH-1:0] RAM [DEPTH-1:0];
reg [WIDTH-1:0] read_data_reg;

always @(posedge clk) begin
    if (!rst_n) begin
        for (int i = 0; i < DEPTH; i++) begin
            RAM[i] <= {WIDTH{1'b0}};
        end
        read_data_reg <= {WIDTH{1'b0}};
    end else if (write_en) begin
        RAM[write_addr] <= write_data;
    end
    if (read_en) begin
        read_data_reg <= RAM[read_addr];
    end
end

assign read_data = read_data_reg;

endmodule