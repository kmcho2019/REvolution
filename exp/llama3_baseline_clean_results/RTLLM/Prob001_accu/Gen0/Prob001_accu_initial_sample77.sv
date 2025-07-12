module accu(
    input           clk,
    input           rst_n,
    input  [7:0]    data_in,
    input           valid_in,
    output          valid_out,
    output [9:0]    data_out
);

reg [9:0]          accu_sum;
reg [1:0]          cnt;
reg                valid_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        accu_sum <= 10'd0;
        cnt <= 2'd0;
        valid_out_reg <= 1'd0;
    end else if (valid_in) begin
        if (cnt == 4'd3) begin
            accu_sum <= accu_sum + data_in;
            valid_out_reg <= 1'd1;
            cnt <= 2'd0;
        end else begin
            accu_sum <= accu_sum + data_in;
            cnt <= cnt + 1'd1;
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
assign data_out = accu_sum;

endmodule