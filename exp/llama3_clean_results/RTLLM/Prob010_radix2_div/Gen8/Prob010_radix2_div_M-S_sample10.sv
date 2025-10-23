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
reg [8:0] sr;  // shift register
reg [7:0] quotient;  // quotient
reg [7:0] remainder;  // remainder
reg [3:0] cnt;  // counter
reg start_cnt;  // start counter flag

always @(posedge clk or posedge rst) begin
    if (rst) begin
        dividend_reg <= 0;
        divisor_reg <= 0;
        sr <= 0;
        quotient <= 0;
        remainder <= 0;
        cnt <= 0;
        start_cnt <= 0;
        res_valid <= 0;
        result <= 0;
    end else begin
        if (opn_valid &&!res_valid) begin
            // Save inputs
            if (sign) begin
                dividend_reg <= (dividend[7]? ~dividend + 1 : dividend);
                divisor_reg <= (divisor[7]? ~divisor + 1 : divisor);
            end else begin
                dividend_reg <= dividend;
                divisor_reg <= divisor;
            end
            sr <= {1'b0, dividend_reg};
            cnt <= 1;
            start_cnt <= 1;
            res_valid <= 0;
        end
        
        if (start_cnt) begin
            if (cnt < 9) begin
                if (sr[8] == 0) begin
                    if (sr[7:0] >= divisor_reg) begin
                        sr <= {sr[7:0] - divisor_reg, 0};
                        quotient <= quotient + (1 << (8 - cnt));
                    end else begin
                        sr <= {sr[7:0], 0};
                    end
                end else begin
                    if ({sr[8], sr[7:0]} >= {1'b0, divisor_reg}) begin
                        sr <= {sr[7:0] - divisor_reg, 0};
                        quotient <= quotient + (1 << (8 - cnt));
                    end else begin
                        sr <= {sr[7:0], 0};
                    end
                end
                cnt <= cnt + 1;
            end else begin
                remainder <= sr[7:0];
                res_valid <= 1;
                result <= {remainder, quotient};
                start_cnt <= 0;
            end
        end
    end
end

endmodule