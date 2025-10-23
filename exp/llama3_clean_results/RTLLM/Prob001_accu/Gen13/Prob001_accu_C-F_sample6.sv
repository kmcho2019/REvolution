module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output valid_out,
    output [9:0] data_out
);

reg [1:0] cnt_reg;
reg [9:0] sum_reg;
reg clk_enable;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt_reg <= 0;
        sum_reg <= 0;
        clk_enable <= 0;
    end else if (valid_in) begin
        clk_enable <= 1;
        if (cnt_reg == 0) begin
            sum_reg <= data_in;
            cnt_reg <= 1;
        end else if (cnt_reg == 1) begin
            sum_reg <= sum_reg + data_in;
            cnt_reg <= 2;
        end else if (cnt_reg == 2) begin
            sum_reg <= sum_reg + data_in;
            cnt_reg <= 3;
        end else if (cnt_reg == 3) begin
            sum_reg <= sum_reg + data_in;
            cnt_reg <= 0;
        end
    end else begin
        clk_enable <= 0;
        cnt_reg <= 0;
        sum_reg <= 0;
    end
end

assign valid_out = (cnt_reg == 0) && (sum_reg != 0);
assign data_out = sum_reg;

// Clock gating
reg [9:0] sum_reg_gated;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_reg_gated <= 0;
    end else if (clk_enable) begin
        sum_reg_gated <= sum_reg;
    end
end

assign data_out = sum_reg_gated;

endmodule