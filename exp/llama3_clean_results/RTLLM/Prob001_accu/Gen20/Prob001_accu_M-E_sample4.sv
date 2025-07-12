module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output valid_out,
    output [9:0] data_out
);

reg [31:0] shift_reg;
reg [1:0] cnt_reg;
reg [9:0] sum_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= 0;
        cnt_reg <= 0;
        sum_reg <= 0;
    end else if (valid_in) begin
        shift_reg <= {shift_reg[23:0], data_in};
        cnt_reg <= cnt_reg + 1;
        if (cnt_reg == 4) begin
            sum_reg <= shift_reg[7:0] + shift_reg[15:8] + shift_reg[23:16] + shift_reg[31:24];
            cnt_reg <= 0;
        end
    end
end

assign valid_out = (cnt_reg == 0) && (sum_reg != 0);
assign data_out = sum_reg;

endmodule