module accu(
    input           clk,
    input           rst_n,
    input   [7:0]   data_in,
    input           valid_in,
    output          valid_out,
    output  [9:0]   data_out
);

reg [9:0] accu_reg;
reg [1:0] cnt_reg;
reg       valid_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        accu_reg <= 0;
        cnt_reg <= 0;
        valid_out_reg <= 0;
    end else if (valid_in) begin
        if (cnt_reg < 2'd3) begin
            accu_reg <= accu_reg + {{2{data_in[7]}}, data_in};
            cnt_reg <= cnt_reg + 1;
        end else begin
            accu_reg <= accu_reg + {{2{data_in[7]}}, data_in};
            cnt_reg <= 0;
            valid_out_reg <= 1;
        end
    end else begin
        valid_out_reg <= 0;
    end
end

assign valid_out = valid_out_reg;
assign data_out = accu_reg;

endmodule