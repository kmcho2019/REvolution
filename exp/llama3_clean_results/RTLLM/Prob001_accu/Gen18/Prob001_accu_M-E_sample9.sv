module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output valid_out,
    output [9:0] data_out
);

reg [31:0] shift_reg;
reg [1:0] cnt;
reg [9:0] sum;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= 0;
        cnt <= 0;
        sum <= 0;
    end else begin
        if (valid_in) begin
            shift_reg <= {shift_reg[23:0], data_in};
            cnt <= cnt + 1;
            if (cnt == 4) begin
                sum <= shift_reg[7:0] + shift_reg[15:8] + shift_reg[23:16] + shift_reg[31:24];
                cnt <= 0;
            end
        end else begin
            shift_reg <= 0;
            cnt <= 0;
            sum <= 0;
        end
    end
end

assign valid_out = (cnt == 0) && (sum != 0);
assign data_out = sum;

endmodule