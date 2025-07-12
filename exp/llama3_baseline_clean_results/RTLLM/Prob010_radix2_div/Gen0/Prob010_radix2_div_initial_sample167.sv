module radix2_div(
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output res_valid,
    output [15:0] result
);

reg [7:0] dividend_reg;
reg [7:0] divisor_reg;
reg [15:0] shift_reg;
reg [7:0] neg_divisor;
reg [3:0] cnt;
reg start_cnt;
reg res_valid_reg;
reg [7:0] quotient;
reg [7:0] remainder;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid_reg <= 0;
        start_cnt <= 0;
        cnt <= 0;
        shift_reg <= 0;
    end else if (opn_valid &&!res_valid_reg) begin
        dividend_reg <= (sign)? {{7{dividend[7]}}, dividend[7:0]} : dividend;
        divisor_reg <= (sign)? {{7{divisor[7]}}, divisor[7:0]} : divisor;
        shift_reg <= {1'b0, dividend_reg};
        neg_divisor <= ~divisor_reg + 1;
        cnt <= 1;
        start_cnt <= 1;
    end else if (start_cnt) begin
        if (cnt == 8) begin
            start_cnt <= 0;
            cnt <= 0;
            quotient <= shift_reg[7:0];
            remainder <= shift_reg[15:8];
            res_valid_reg <= 1;
        end else begin
            cnt <= cnt + 1;
            if (shift_reg[15] == 1'b0) begin
                shift_reg <= {shift_reg[15:1], 1'b0};
            end else begin
                shift_reg <= {shift_reg[15:1], 1'b1};
            end
            if (shift_reg[15:8] >= neg_divisor) begin
                shift_reg[15:8] <= shift_reg[15:8] - neg_divisor;
                shift_reg[0] <= 1'b1;
            end else begin
                shift_reg[0] <= 1'b0;
            end
        end
    end
end

always @(posedge clk) begin
    if (res_valid_reg &&!opn_valid) begin
        res_valid_reg <= 0;
    end
end

assign res_valid = res_valid_reg;
assign result = {remainder, quotient};

endmodule