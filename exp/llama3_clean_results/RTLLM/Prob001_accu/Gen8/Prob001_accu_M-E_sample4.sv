module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output valid_out,
    output [9:0] data_out
);

reg [7:0] shift_reg [3:0];
reg [1:0] cnt_reg;
reg [9:0] sum_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt_reg <= 0;
        shift_reg <= '{default: 0};
        sum_reg <= 0;
    end else if (valid_in) begin
        shift_reg[0] <= data_in;
        shift_reg[1] <= (cnt_reg == 0)? 0 : shift_reg[0];
        shift_reg[2] <= (cnt_reg == 1)? 0 : shift_reg[1];
        shift_reg[3] <= (cnt_reg == 2)? 0 : shift_reg[2];
        cnt_reg <= (cnt_reg == 3)? 0 : cnt_reg + 1;
        if (cnt_reg == 3) begin
            sum_reg <= shift_reg[0] + shift_reg[1] + shift_reg[2] + shift_reg[3];
        end else begin
            sum_reg <= 0;
        end
    end
end

assign valid_out = (cnt_reg == 0) && (sum_reg!= 0);
assign data_out = sum_reg;

endmodule