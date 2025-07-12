module radix2_div(
    input  clk,
    input  rst,
    input  sign,
    input  [7:0] dividend,
    input  [7:0] divisor,
    input  opn_valid,
    output res_valid,
    output [15:0] result
);

reg [15:0] SR; // Shift Register
reg [7:0] NEG_DIVISOR; // Negated Absolute Value of Divisor
reg [3:0] cnt; // Counter for Division Process
reg start_cnt; // Flag to Start Division
reg [7:0] dividend_abs; // Absolute Value of Dividend
reg [7:0] divisor_abs; // Absolute Value of Divisor
reg quotient_sign; // Sign of Quotient
reg [7:0] quotient; // Quotient
reg [7:0] remainder; // Remainder

always @(posedge clk or posedge rst) begin
    if(rst) begin
        SR <= 0;
        NEG_DIVISOR <= 0;
        cnt <= 0;
        start_cnt <= 0;
        res_valid <= 0;
        dividend_abs <= 0;
        divisor_abs <= 0;
        quotient_sign <= 0;
        quotient <= 0;
        remainder <= 0;
    end else begin
        if(opn_valid && !res_valid) begin
            // Save Inputs and Initialize Registers
            dividend_abs <= (sign) ? {8{dividend[7]}} ^ dividend + (dividend[7] ? 8'd1 : 8'd0) : dividend;
            divisor_abs <= (sign) ? {8{divisor[7]}} ^ divisor + (divisor[7] ? 8'd1 : 8'd0) : divisor;
            NEG_DIVISOR <= (sign) ? ~divisor_abs + 1 : divisor_abs;
            SR <= {1'b0, dividend_abs};
            cnt <= 1;
            start_cnt <= 1;
        end

        if(start_cnt) begin
            if(cnt == 8) begin
                // Division Complete
                start_cnt <= 0;
                res_valid <= 1;
                quotient <= SR[7:0];
                remainder <= SR[15:8];
                if(sign) begin
                    if(dividend[7] != divisor[7]) begin
                        quotient_sign <= 1'b1;
                        quotient <= ~quotient + 1;
                    end
                    remainder <= (dividend[7]) ? ~remainder + 1 : remainder;
                end
            end else begin
                // Perform Division Step
                if(SR[15:8] >= NEG_DIVISOR) begin
                    // Subtract NEG_DIVISOR from SR
                    SR <= (SR[15:8] - NEG_DIVISOR) << 8 | SR[7:0] | 1'b1;
                end else begin
                    SR <= SR << 1;
                end
                cnt <= cnt + 1;
            end
        end

        // Reset Result Validity
        if(rst || (opn_valid && res_valid)) begin
            res_valid <= 0;
        end
    end
end

assign result = {remainder, quotient};

endmodule