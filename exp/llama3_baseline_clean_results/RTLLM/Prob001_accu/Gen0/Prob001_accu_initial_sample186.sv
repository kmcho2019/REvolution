module accu(
    input           clk,
    input           rst_n,
    input  [7:0]    data_in,
    input           valid_in,
    output          valid_out,
    output [9:0]    data_out
);

reg [9:0]          sum_reg;
reg [1:0]          cnt_reg;
reg                valid_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum_reg <= 10'd0;
        cnt_reg <= 2'd0;
        valid_out_reg <= 1'd0;
    end else if (valid_in) begin
        if (cnt_reg == 2'd3) begin
            sum_reg <= sum_reg + data_in;
            cnt_reg <= 2'd0;
            valid_out_reg <= 1'd1;
        end else begin
            sum_reg <= sum_reg + data_in;
            cnt_reg <= cnt_reg + 1'd1;
            valid_out_reg <= 1'd0;
        end
    end else begin
        valid_out_reg <= 1'd0;
    end
end

always @(posedge clk) begin
    if (valid_out_reg) begin
        valid_out_reg <= 1'd0;
    end
end

assign valid_out = valid_out_reg;
assign data_out = sum_reg;

endmodule