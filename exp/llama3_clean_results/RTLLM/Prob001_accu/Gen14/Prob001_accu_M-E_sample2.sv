module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output valid_out,
    output [9:0] data_out
);

reg [1:0] cnt;
reg [7:0] shift_reg [0:2];
reg [9:0] sum;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 0;
        shift_reg[0] <= 0;
        shift_reg[1] <= 0;
        shift_reg[2] <= 0;
        sum <= 0;
    end else if (valid_in) begin
        if (cnt == 0) begin
            shift_reg[0] <= data_in;
            cnt <= cnt + 1;
        end else if (cnt == 1) begin
            shift_reg[1] <= data_in;
            cnt <= cnt + 1;
        end else if (cnt == 2) begin
            shift_reg[2] <= data_in;
            cnt <= cnt + 1;
        end else if (cnt == 3) begin
            sum <= shift_reg[0] + shift_reg[1] + shift_reg[2] + data_in;
            cnt <= 0;
        end
    end
end

assign valid_out = (cnt == 0) && (sum!= 0);
assign data_out = sum;

endmodule