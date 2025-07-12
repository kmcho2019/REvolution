module RAM(
    input         clk,
    input         rst_n,
    input         write_en,
    input  [2:0]   write_addr,
    input  [5:0]   write_data,
    input         read_en,
    input  [2:0]   read_addr,
    output [5:0]   read_data
);

parameter WIDTH = 6;
parameter DEPTH = 8;

reg [5:0] RAM [7:0];

reg [5:0] read_data_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (int i = 0; i < DEPTH; i++) begin
            RAM[i] <= 6'd0;
        end
    end else if (write_en) begin
        RAM[write_addr] <= write_data;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        read_data_reg <= 6'd0;
    end else if (read_en) begin
        read_data_reg <= RAM[read_addr];
    end else begin
        read_data_reg <= 6'd0;
    end
end

assign read_data = read_data_reg;

endmodule