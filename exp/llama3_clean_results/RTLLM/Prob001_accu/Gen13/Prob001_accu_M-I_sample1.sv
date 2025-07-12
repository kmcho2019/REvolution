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

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt_reg <= 0;
        sum_reg <= 0;
    end else if (valid_in) begin
        sum_reg <= sum_reg + data_in;
        cnt_reg <= cnt_reg + 1;
        if (cnt_reg == 3) begin
            cnt_reg <= 0;
        end
    end
end

assign valid_out = (cnt_reg == 0) && (sum_reg != 0);
assign data_out = sum_reg;

endmodule