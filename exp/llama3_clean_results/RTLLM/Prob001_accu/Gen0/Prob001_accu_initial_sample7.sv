module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output valid_out,
    output [9:0] data_out
);

reg [9:0] data_out_reg;
reg valid_out_reg;
reg [1:0] cnt_reg;
reg [9:0] sum_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        valid_out_reg <= 0;
        data_out_reg <= 0;
        cnt_reg <= 0;
        sum_reg <= 0;
    end else if (valid_in) begin
        if (cnt_reg == 0) begin
            sum_reg <= data_in;
            cnt_reg <= cnt_reg + 1;
        end else if (cnt_reg < 4) begin
            sum_reg <= sum_reg + data_in;
            cnt_reg <= cnt_reg + 1;
        end else begin
            sum_reg <= sum_reg + data_in;
            data_out_reg <= sum_reg;
            valid_out_reg <= 1;
            cnt_reg <= 0;
            sum_reg <= 0;
        end
    end else begin
        valid_out_reg <= 0;
    end
end

assign valid_out = valid_out_reg;
assign data_out = data_out_reg;

endmodule