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
        accu_reg <= 10'b0;
        cnt_reg <= 2'b0;
        valid_out_reg <= 1'b0;
    end else if (valid_in) begin
        if (cnt_reg == 2'b11) begin
            accu_reg <= accu_reg + data_in;
            cnt_reg <= cnt_reg + 1'b1;
            valid_out_reg <= 1'b1;
        end else begin
            accu_reg <= accu_reg + data_in;
            cnt_reg <= cnt_reg + 1'b1;
            valid_out_reg <= 1'b0;
        end
    end else begin
        if (cnt_reg == 2'b11) begin
            valid_out_reg <= 1'b0;
            accu_reg <= 10'b0;
            cnt_reg <= 2'b0;
        end else begin
            valid_out_reg <= 1'b0;
        end
    end
end

assign valid_out = (cnt_reg == 2'b11) && valid_out_reg;
assign data_out = (cnt_reg == 2'b11) ? accu_reg : 10'b0;

endmodule