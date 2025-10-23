module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output valid_out,
    output [9:0] data_out
);

reg [7:0] fifo[3:0];
reg [1:0] cnt_reg;
reg [9:0] sum_reg;
reg load_fifo;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt_reg <= 0;
        sum_reg <= 0;
        load_fifo <= 0;
        valid_out <= 0;
    end else begin
        valid_out <= 0;
        if (valid_in && (cnt_reg < 4)) begin
            fifo[cnt_reg] <= data_in;
            cnt_reg <= cnt_reg + 1;
        end
        if (cnt_reg == 4) begin
            sum_reg <= fifo[0] + fifo[1] + fifo[2] + fifo[3];
            valid_out <= 1;
            cnt_reg <= 0;
        end
    end
end

assign data_out = sum_reg;

endmodule