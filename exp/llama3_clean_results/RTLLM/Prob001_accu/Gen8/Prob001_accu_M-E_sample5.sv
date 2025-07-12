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
wire [9:0] sum;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt_reg <= 0;
        for (int i = 0; i < 4; i++) begin
            shift_reg[i] <= 0;
        end
    end else if (valid_in) begin
        shift_reg[0] <= data_in;
        for (int i = 1; i < 4; i++) begin
            shift_reg[i] <= shift_reg[i-1];
        end
        cnt_reg <= (cnt_reg == 3) ? 0 : cnt_reg + 1;
    end
end

assign sum = shift_reg[0] + shift_reg[1] + shift_reg[2] + shift_reg[3];
assign valid_out = (cnt_reg == 3) && valid_in;
assign data_out = sum;

endmodule