module accu (
    input               clk,
    input               rst_n,
    input      [7:0]    data_in,
    input               valid_in,
    output              valid_out,
    output     [9:0]    data_out
);

reg [7:0]  data_reg [0:3];
reg [1:0]  cnt_reg;
reg [9:0]  sum_reg;
reg        valid_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt_reg <= 2'd0;
        sum_reg <= 10'd0;
        valid_out_reg <= 1'd0;
    end else if (valid_in) begin
        if (cnt_reg < 2'd3) begin
            data_reg[cnt_reg] <= data_in;
            cnt_reg <= cnt_reg + 1'd1;
        end else begin
            sum_reg <= data_in + data_reg[0] + data_reg[1] + data_reg[2];
            valid_out_reg <= 1'd1;
            cnt_reg <= 2'd0;
        end
    end else begin
        valid_out_reg <= 1'd0;
    end
end

always @(posedge clk) begin
    if (~rst_n) begin
        valid_out <= 1'd0;
    end else if (valid_out_reg) begin
        data_out <= sum_reg;
        valid_out <= valid_out_reg;
        valid_out_reg <= 1'd0;
    end else begin
        valid_out <= 1'd0;
    end
end

endmodule