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
        valid_out <= 0;
    end else begin
        valid_out <= 0;
        if (valid_in) begin
            if (cnt_reg == 4'b0000) begin
                sum_reg <= data_in;
                cnt_reg <= 4'b0001;
            end else if (cnt_reg == 4'b0001) begin
                sum_reg <= sum_reg + data_in;
                cnt_reg <= 4'b0010;
            end else if (cnt_reg == 4'b0010) begin
                sum_reg <= sum_reg + data_in;
                cnt_reg <= 4'b0011;
            end else if (cnt_reg == 4'b0011) begin
                sum_reg <= sum_reg + data_in;
                cnt_reg <= 4'b0000;
                valid_out <= 1;
            end
        end
    end
end

assign data_out = sum_reg;

endmodule