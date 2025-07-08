module radix2_div (
    input         clk,
    input         rst,
    input         sign,
    input  [7:0]  dividend,
    input  [7:0]  divisor,
    input         opn_valid,
    output reg    res_valid,
    output reg [15:0] result
);

    // Internal registers
    reg [8:0] SR;           // Shift register: holds remainder(8 bits) and quotient(1 bit) during division
    reg [7:0] NEG_DIVISOR;  // Negated absolute divisor for subtraction
    reg [3:0] cnt;          // Counter for division steps (1 to 8)
    reg        start_cnt;   // Start division flag

    // Latched inputs and sign flags
    reg [7:0] dividend_latched;
    reg [7:0] divisor_latched;
    reg       dividend_sign;
    reg       divisor_sign;

    // Absolute values
    wire [7:0] abs_dividend;
    wire [7:0] abs_divisor;

    // Compute absolute value based on sign bit
    assign abs_dividend = (sign && dividend_latched[7]) ? (~dividend_latched + 1'b1) : dividend_latched;
    assign abs_divisor  = (sign && divisor_latched[7])  ? (~divisor_latched  + 1'b1) : divisor_latched;

    // Subtraction result wire and carry out
    wire [8:0] sub_res;
    wire       sub_cout;

    // Perform subtraction: SR[8:1] - abs_divisor
    assign {sub_cout, sub_res} = {1'b0, SR[8:1]} + {1'b0, ~abs_divisor} + 1'b1;

    // After division complete, sign adjustment signals
    wire quotient_sign;
    wire remainder_sign;

    // Quotient and remainder before sign adjustment
    wire [7:0] quotient_raw;
    wire [7:0] remainder_raw;

    assign quotient_raw  = SR[7:0];
    assign remainder_raw = SR[8:1];

    // Determine signs of quotient and remainder
    assign quotient_sign = dividend_sign ^ divisor_sign;
    assign remainder_sign = dividend_sign;

    // Sign adjusted quotient and remainder
    wire [7:0] quotient_signed;
    wire [7:0] remainder_signed;

    assign quotient_signed  = (sign && quotient_sign)  ? (~quotient_raw + 1'b1)  : quotient_raw;
    assign remainder_signed = (sign && remainder_sign) ? (~remainder_raw + 1'b1) : remainder_raw;

    // Sequential logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            cnt <= 0;
            start_cnt <= 1'b0;
            SR <= 9'b0;
            NEG_DIVISOR <= 8'b0;
            dividend_latched <= 8'b0;
            divisor_latched <= 8'b0;
            dividend_sign <= 1'b0;
            divisor_sign <= 1'b0;
            res_valid <= 1'b0;
            result <= 16'b0;
        end else begin
            // Start operation when opn_valid asserted and no result pending
            if (opn_valid && !res_valid) begin
                dividend_latched <= dividend;
                divisor_latched  <= divisor;
                dividend_sign <= (sign && dividend[7]);
                divisor_sign  <= (sign && divisor[7]);

                // Initialize SR with absolute dividend shifted left by 1 (extra bit)
                SR <= {abs_dividend, 1'b0};

                // NEG_DIVISOR = -abs_divisor = two's complement of abs_divisor
                NEG_DIVISOR <= ~abs_divisor + 1'b1;

                cnt <= 1;
                start_cnt <= 1'b1;

                // Clear previous result valid
                res_valid <= 1'b0;
            end else if (start_cnt) begin
                if (cnt == 8) begin
                    // Division complete
                    cnt <= 0;
                    start_cnt <= 1'b0;

                    // Final SR update: remainder and quotient available in SR
                    // Sign-adjust quotient and remainder before output
                    result <= {remainder_signed, quotient_signed};
                    res_valid <= 1'b1;
                end else begin
                    // Perform subtraction test
                    // If subtraction result >= 0 (sub_cout == 1), update SR accordingly:
                    // Shift left by 1, insert quotient bit = 1 if subtraction successful, else 0
                    // If subtraction succeeded, update upper bits of SR with sub_res
                    if (sub_cout) begin
                        // Successful subtraction: update remainder part with sub_res, shift in 1 bit quotient
                        SR <= {sub_res[7:0], SR[0], 1'b1};
                    end else begin
                        // Subtraction failed: shift left, quotient bit = 0
                        SR <= {SR[7:0], SR[0], 1'b0};
                    end
                    cnt <= cnt + 1'b1;
                end
            end else if (res_valid && !opn_valid) begin
                // Result consumed, clear valid flag
                res_valid <= 1'b0;
            end
        end
    end

endmodule