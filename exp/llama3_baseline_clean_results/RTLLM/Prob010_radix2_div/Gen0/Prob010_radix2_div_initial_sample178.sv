module radix2_div (
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output reg res_valid,
    output reg [15:0] result
);

reg [15:0] SR; // Shift register to store the current remainder and quotient
reg [7:0] NEG_DIVISOR; // Negated absolute value of the divisor
reg [3:0] cnt; // Counter to keep track of the division steps
reg start_cnt; // Flag to indicate the start of the division process
reg [7:0] abs_dividend; // Absolute value of the dividend
reg [7:0] abs_divisor; // Absolute value of the divisor
reg [7:0] quotient; // Quotient of the division

always @(posedge clk) begin
    if (rst) begin
        SR <= 0;
        NEG_DIVISOR <= 0;
        cnt <= 0;
        start_cnt <= 0;
        res_valid <= 0;
        result <= 0;
    end else begin
        if (opn_valid && !res_valid) begin
            // Initialize the shift register and counter
            abs_dividend <= (sign) ? {dividend[7], dividend} : dividend;
            abs_divisor <= (sign) ? {divisor[7], divisor} : divisor;
            SR <= {1'b0, abs_dividend};
            NEG_DIVISOR <= ~abs_divisor + 1;
            cnt <= 1;
            start_cnt <= 1;
        end

        if (start_cnt) begin
            if (cnt == 8) begin
                // Division is complete, update the result
                quotient <= SR[7:0];
                result <= {abs_dividend - (SR[7:0] * abs_divisor), quotient};
                res_valid <= 1;
                start_cnt <= 0;
            end else begin
                // Update the shift register and counter
                if (SR[15] == 0) begin
                    SR <= {SR[14:0], 0} - {1'b0, NEG_DIVISOR};
                end else begin
                    SR <= {SR[14:0], 1} - {1'b0, NEG_DIVISOR};
                end
                cnt <= cnt + 1;
            end
        end

        if (res_valid && !opn_valid) begin
            // Result has been consumed, reset the flags
            res_valid <= 0;
        end
    end
end

endmodule