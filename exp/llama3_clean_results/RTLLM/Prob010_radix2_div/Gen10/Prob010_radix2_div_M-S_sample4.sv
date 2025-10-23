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

reg [7:0] dividend_reg;  // registered dividend
reg [7:0] divisor_reg;  // registered divisor
reg [15:0] sr;  // shift register with 8 extra bits for remainder and quotient
reg [3:0] cnt;  // counter
reg start_cnt;  // start counter flag

always @(posedge clk or posedge rst) begin
    if (rst) begin
        sr <= 0;
        cnt <= 0;
        start_cnt <= 0;
        res_valid <= 0;
    end else begin
        if (opn_valid && !res_valid) begin
            if (sign) begin
                // Signed division
                dividend_reg <= (dividend[7]? ~dividend + 1 : dividend);
                divisor_reg <= (divisor[7]? ~divisor + 1 : divisor);
            end else begin
                // Unsigned division
                dividend_reg <= dividend;
                divisor_reg <= divisor;
            end
            sr <= {8'd0, dividend_reg};
            cnt <= 1;
            start_cnt <= 1;
            res_valid <= 0;
        end

        if (start_cnt) begin
            if (cnt < 8) begin
                reg [8:0] temp;
                temp <= {1'b0, sr[15:8]} - {1'b0, divisor_reg};
                if (temp[8]) begin
                    // Borrow
                    sr <= {sr[15:8] + divisor_reg, sr[7:0], 1'b0};
                end else begin
                    // No borrow
                    sr <= {temp[7:0], sr[7:0], 1'b1};
                end
                cnt <= cnt + 1;
            end else begin
                result <= {sr[15:8], sr[7:0]};
                res_valid <= 1;
                start_cnt <= 0;
            end
        end
    end
end

endmodule