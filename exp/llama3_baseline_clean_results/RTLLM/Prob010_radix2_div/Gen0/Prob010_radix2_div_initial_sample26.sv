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

reg [7:0] SR; // Shift register
reg [7:0] NEG_DIVISOR; // Negated absolute value of divisor
reg [3:0] cnt; // Counter
reg start_cnt; // Start counter flag
reg [7:0] dividend_reg; // Registered dividend
reg [7:0] divisor_reg; // Registered divisor
reg res_valid_reg; // Registered result validity

always @(posedge clk or posedge rst) begin
    if (rst) begin
        SR <= 0;
        NEG_DIVISOR <= 0;
        cnt <= 0;
        start_cnt <= 0;
        dividend_reg <= 0;
        divisor_reg <= 0;
        res_valid_reg <= 0;
    end else begin
        if (opn_valid && !res_valid_reg) begin
            // Initialize registers and start counter
            dividend_reg <= dividend;
            divisor_reg <= divisor;
            SR <= {1'b0, dividend_reg}; // Shift dividend left by one bit
            NEG_DIVISOR <= ~divisor_reg + 1; // Two's complement of divisor
            cnt <= 1;
            start_cnt <= 1;
            res_valid_reg <= 0;
        end else if (start_cnt) begin
            // Division process
            if (cnt == 8) begin
                // Division complete, update result
                start_cnt <= 0;
                cnt <= 0;
                if (sign) begin
                    // Signed division, adjust result accordingly
                    if (dividend_reg[7] && !divisor_reg[7]) begin
                        result <= {SR[7:0], ~(SR[7:0] - divisor_reg) + 1};
                    end else if (!dividend_reg[7] && divisor_reg[7]) begin
                        result <= {SR[7:0], ~(SR[7:0] - divisor_reg) + 1};
                    end else begin
                        result <= {SR[7:0], SR[7:0]};
                    end
                end else begin
                    // Unsigned division
                    result <= {SR[7:0], SR[7:0]};
                end
                res_valid_reg <= 1;
            end else begin
                // Update shift register and counter
                if (SR[7] == 0) begin
                    // No borrow, shift left and insert 0
                    SR <= {SR[6:0], 1'b0};
                end else begin
                    // Borrow, shift left and insert 1
                    SR <= {SR[6:0], 1'b1};
                end
                cnt <= cnt + 1;
            end
        end
    end
end

assign res_valid = res_valid_reg;

endmodule