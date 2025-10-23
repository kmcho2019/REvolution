module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output valid_out,
    output [9:0] data_out
);

reg [7:0] shift_reg [3:0];
reg [9:0] sum;

integer i;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (i = 0; i < 4; i++) begin
            shift_reg[i] <= 0;
        end
    end else if (valid_in) begin
        shift_reg[3:1] <= shift_reg[2:0];
        shift_reg[0] <= data_in;
    end
end

assign sum = shift_reg[0] + shift_reg[1] + shift_reg[2] + shift_reg[3];
assign valid_out = (shift_reg[3] != 0) && (data_in != 0);
assign data_out = sum;

endmodule