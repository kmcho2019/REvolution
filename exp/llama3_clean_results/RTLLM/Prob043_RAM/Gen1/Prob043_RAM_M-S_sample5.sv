module RAM(
    input clk,
    input rst_n,
    input write_en,
    input [2:0] write_addr,
    input [5:0] write_data,
    input read_en,
    input [2:0] read_addr,
    output reg [5:0] read_data
);

localparam WIDTH = 6;
localparam DEPTH = 8;

reg [WIDTH-1:0] RAM [DEPTH-1:0];

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        read_data <= 6'd0;
        for (int i = 0; i < DEPTH; i++) begin
            RAM[i] <= 6'd0;
        end
    end else begin
        if (write_en) begin
            RAM[write_addr] <= write_data;
        end
        if (read_en) begin
            read_data <= RAM[read_addr];
        end else begin
            read_data <= 6'd0;
        end
    end
end

endmodule