module radix2_div (
    input         clk,
    input         rst,
    input         sign,          // 1: signed division, 0: unsigned
    input  [7:0]  dividend,
    input  [7:0]  divisor,
    input         opn_valid,
    output reg    res_valid,
    output reg [15:0] result      // [15:8] remainder, [7:0] quotient
);

    // Registers to store input values and signs
    reg [7:0] dividend_reg;
    reg [7:0] divisor_reg;
    reg       sign_reg;

    // Flags for input signs
    reg       dividend_neg;
    reg       divisor_neg;
    reg       quotient_neg;

    // Absolute values of inputs
    reg [7:0] abs_dividend;
    reg [7:0] abs_divisor;

    // 9-bit remainder register, upper bits hold remainder
    reg [8:0] remainder;

    // 8-bit quotient register
    reg [7:0] quotient;

    // Negated divisor extended to 9 bits (for subtractive trial)
    reg [8:0] neg_divisor;

    // Counter for iteration steps (0 to 7)
    reg [3:0] cnt;

    // Busy flag to indicate ongoing operation
    reg busy;

    // Combinational subtraction (remainder - divisor)
    wire [9:0] sub_result = {1'b0, remainder} + {~neg_divisor + 9'b1}; 
    // Note: neg_divisor already negated => remainder + neg_divisor

    wire sub_non_negative = ~sub_result[9]; // MSB is sign bit for 10-bit result

    // Initialization and input registration
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            dividend_reg <= 8'd0;
            divisor_reg <= 8'd0;
            sign_reg <= 1'b0;
            dividend_neg <= 1'b0;
            divisor_neg <= 1'b0;
            quotient_neg <= 1'b0;
            abs_dividend <= 8'd0;
            abs_divisor <= 8'd0;
            remainder <= 9'd0;
            quotient <= 8'd0;
            neg_divisor <= 9'd0;
            cnt <= 4'd0;
            busy <= 1'b0;
            res_valid <= 1'b0;
            result <= 16'd0;
        end else begin
            if (!busy) begin
                res_valid <= 1'b0;
                if (opn_valid) begin
                    // Register inputs and signs
                    dividend_reg <= dividend;
                    divisor_reg <= divisor;
                    sign_reg <= sign;

                    if (sign) begin
                        dividend_neg <= dividend[7];
                        divisor_neg <= divisor[7];
                        abs_dividend <= dividend[7] ? (~dividend + 1'b1) : dividend;
                        abs_divisor <= divisor[7] ? (~divisor + 1'b1) : divisor;
                        quotient_neg <= dividend[7] ^ divisor[7];
                    end else begin
                        dividend_neg <= 1'b0;
                        divisor_neg <= 1'b0;
                        abs_dividend <= dividend;
                        abs_divisor <= divisor;
                        quotient_neg <= 1'b0;
                    end

                    // Initialize remainder: dividend absolute value shifted left by 1 (9 bits)
                    remainder <= {abs_dividend, 1'b0};

                    // Initialize quotient to zero
                    quotient <= 8'd0;

                    // Negate divisor extended to 9 bits for subtraction
                    neg_divisor <= (~{1'b0, abs_divisor}) + 9'd1;

                    // Reset counter and set busy flag
                    cnt <= 4'd0;
                    busy <= 1'b1;
                end
            end else begin
                // Perform division steps while busy
                if (cnt < 4'd8) begin
                    // Subtract divisor trial: remainder + neg_divisor
                    // If non-negative, update remainder and set quotient bit to 1
                    if (sub_non_negative) begin
                        remainder <= sub_result[8:0]; // Keep lower 9 bits as remainder
                        quotient <= {quotient[6:0], 1'b1};
                    end else begin
                        // Restore remainder, quotient bit = 0
                        remainder <= remainder;
                        quotient <= {quotient[6:0], 1'b0};
                    end
                    cnt <= cnt + 1'b1;
                end else begin
                    // Division complete
                    busy <= 1'b0;
                    res_valid <= 1'b1;
                end
            end
        end
    end

    // Signed correction of quotient and remainder after division done
    // Do this combinationally and register final result on res_valid pulse

    wire [7:0] quotient_unsigned = quotient;
    wire [8:0] remainder_unsigned = remainder; // 9-bit remainder (extra bit at LSB = 0)

    reg [7:0] quotient_signed;
    reg [7:0] remainder_signed;

    always @(*) begin
        // Remainder correction: remainder is always positive or zero after division,
        // but if dividend was negative, remainder sign matches dividend's sign.
        // Adjust remainder accordingly if signed division:
        if (sign_reg && dividend_neg) begin
            remainder_signed = (~remainder_unsigned[8:1] + 1'b1); // Two's complement of upper 8 bits
        end else begin
            remainder_signed = remainder_unsigned[8:1]; // upper 8 bits shift right by 1 (drop LSB)
        end

        // Quotient correction:
        if (sign_reg && quotient_neg) begin
            quotient_signed = (~quotient_unsigned + 1'b1);
        end else begin
            quotient_signed = quotient_unsigned;
        end
    end

    // Register final result when res_valid asserted
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            result <= 16'd0;
        end else if (res_valid) begin
            result <= {remainder_signed, quotient_signed};
        end
    end

endmodule