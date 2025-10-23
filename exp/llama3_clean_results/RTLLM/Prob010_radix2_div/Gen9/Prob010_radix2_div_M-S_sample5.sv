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

reg [7:0] dividend_reg;
reg [7:0] divisor_reg;
reg [7:0] quotient;
reg [7:0] remainder;
reg [3:0] cnt;
reg start_cnt;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        dividend_reg <= 0;
        divisor_reg <= 0;
        quotient <= 0;
        remainder <= 0;
        cnt <= 0;
        start_cnt <= 0;
        res_valid <= 0;
    end else begin
        if (opn_valid && !res_valid) begin
            // Initialize registers
            dividend_reg <= dividend;
            divisor_reg <= divisor;
            remainder <= {1'b0, dividend_reg}; // Shift left by 1 bit
            quotient <= 0;
            cnt <= 1;
            start_cnt <= 1;
        end

        if (start_cnt) begin
            if (cnt == 8) begin
                start_cnt <= 0;
                res_valid <= 1;
                // Update result
                if (sign) begin
                    if (dividend_reg[7] == 1'b1) begin
                        result <= {remainder, quotient};
                    end else begin
                        result <= {remainder, quotient};
                    end
                end else begin
                    result <= {remainder, quotient};
                end
            end else begin
                reg [8:0] temp;
                temp = {1'b0, remainder} - {1'b0, divisor_reg};
                if (temp[8] == 0) begin // No borrow
                    remainder <= temp[7:0];
                    quotient <= quotient + (1 << (8 - cnt));
                end else begin
                    remainder <= remainder;
                end
                cnt <= cnt + 1;
            end
        end

        if (!opn_valid) begin
            res_valid <= 0;
        end
    end
end

endmodule