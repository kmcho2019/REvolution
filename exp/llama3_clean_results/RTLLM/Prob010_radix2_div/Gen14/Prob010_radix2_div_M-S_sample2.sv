module radix2_div(
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output reg res_valid,
    output reg [15:0] result
);

reg [15:0] shift_reg;
reg [7:0] neg_divisor;
reg [3:0] cnt;
reg [15:0] temp_result;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
        cnt <= 0;
        shift_reg <= 0;
        neg_divisor <= 0;
        result <= 0;
    end else begin
        if (opn_valid && !res_valid) begin
            if (sign) begin
                shift_reg <= {8{dividend[7]} ^ dividend, 1'b0};
            end else begin
                shift_reg <= {8'b0, dividend};
            end
            neg_divisor <= (~divisor) + 1;
            cnt <= 1;
        end else if (cnt < 8) begin
            cnt <= cnt + 1;
            if (shift_reg[15:8] >= {8'b0, divisor}) begin
                shift_reg <= {shift_reg[15:8] - {8'b0, divisor}, 1'b1, shift_reg[7:1]};
            end else begin
                shift_reg <= {shift_reg[15:8], 1'b0, shift_reg[7:1]};
            end
        end else if (cnt == 8) begin
            if (sign) begin
                if (dividend[7] == 1'b1) begin
                    temp_result <= {8'b0, ~shift_reg[7:0] + 1};
                end else begin
                    temp_result <= {shift_reg[15:8], shift_reg[7:0]};
                end
            end else begin
                temp_result <= {shift_reg[15:8], shift_reg[7:0]};
            end
            result <= temp_result;
            res_valid <= 1;
            cnt <= 0;
        end

        if (!opn_valid && res_valid) begin
            res_valid <= 0;
        end
    end
end

endmodule