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

parameter WIDTH = 6;
parameter DEPTH = 8;

reg [5:0] RAM [7:0];

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        for(int i = 0; i < DEPTH; i++) begin
            RAM[i] <= 6'd0;
        end
        read_data <= 6'd0;
    end else if(write_en) begin
        RAM[write_addr] <= write_data;
    end
end

assign read_data = read_en? RAM[read_addr] : 6'd0;

endmodule