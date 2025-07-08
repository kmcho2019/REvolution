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
    reg [8:0] SR;           // shift register: 9 bits to hold remainder + quotient bits
    reg [7:0] abs_divisor;  // absolute value of divisor
    reg [7:0] neg_divisor;  // two's complement of abs_divisor (for subtraction)
    reg [3:0] cnt;          // counts from 1 to 8, 4 bits sufficient
    reg        start_cnt;   // indicates division in progress
    reg [7:0] abs_dividend; // absolute value of dividend
    reg        quotient_sign;
    reg        remainder_sign;
    reg        divisor_zero; // flag to detect zero divisor

    wire [8:0] sub_res;
    wire       carry_out;
    wire [8:0] SR_shifted;
    wire [8:0] sub_muxed;

    // Convert dividend and divisor to signed integers for abs calculation
    wire signed [7:0] dividend_signed = dividend;
    wire signed [7:0] divisor_signed = divisor;

    // Absolute value logic for dividend
    always @(*) begin
        if (sign && dividend_signed[7])
            abs_dividend = (~dividend + 1'b1);
        else
            abs_dividend = dividend;
    end

    // Absolute value logic for divisor
    always @(*) begin
        if (sign && divisor_signed[7])
            abs_divisor = (~divisor + 1'b1);
        else
            abs_divisor = divisor;
    end

    // Determine sign of quotient and remainder for signed division
    // quotient_sign = dividend_sign ^ divisor_sign (if signed)
    // remainder_sign = dividend_sign (if signed)
    always @(*) begin
        if (sign) begin
            quotient_sign = dividend_signed[7] ^ divisor_signed[7];
            remainder_sign = dividend_signed[7];
        end else begin
            quotient_sign = 1'b0;
            remainder_sign = 1'b0;
        end
    end

    // Negated divisor (two's complement of abs_divisor)
    always @(*) begin
        neg_divisor = ~abs_divisor + 1'b1;
    end

    // Start division process
    // On opn_valid and res_valid==0 and not dividing, load inputs and initialize registers
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            SR         <= 9'd0;
            cnt        <= 4'd0;
            start_cnt  <= 1'b0;
            res_valid  <= 1'b0;
            result     <= 16'd0;
            divisor_zero <= 1'b0;
        end else begin
            if (opn_valid && !res_valid && !start_cnt) begin
                // Check for divisor zero (division by zero)
                divisor_zero <= (abs_divisor == 8'd0);
                // Load dividend abs shifted left by one bit into SR[8:1], SR[0] = 0
                // SR width: [8:0], remainder in upper bits, quotient in lower bits during process
                SR <= {abs_dividend, 1'b0}; 
                cnt <= 4'd1;
                start_cnt <= 1'b1;
                res_valid <= 1'b0;
            end else if (start_cnt) begin
                // Division process

                // Perform subtraction: SR[8:1] - abs_divisor
                // SR[8:1] is current remainder candidate
                // We'll do: subtraction = SR[8:1] + neg_divisor
                sub_res = SR[8:1] + neg_divisor;
                carry_out = ~sub_res[8]; // carry_out means no borrow if high

                // Update SR:
                // Shift left by 1 bit (dropping MSB), insert carry_out as LSB of quotient
                // New remainder = if carry_out=1, sub_res[7:0], else old remainder (SR[7:0])
                // new SR = {new remainder (8 bits), quotient bits (shifted) + carry_out}
                // Mux remainder part:
                if (carry_out)
                    SR_shifted = {sub_res[7:0], SR[0], 1'b0}; // insert quotient bit = 1 at LSB later
                else
                    SR_shifted = {SR[7:0], SR[0], 1'b0}; // insert quotient bit = 0 at LSB later

                // Actually shift left by 1 bit and insert carry_out as LSB quotient bit
                // SR is 9 bits: upper 8 bits remainder, lower 1 bit quotient bit
                // Shift left by 1: SR_shifted[8:0] = {SR[7:0], SR[0], 1'b0}
                // Then set LSB (bit 0) = carry_out (1 or 0)
                SR <= {SR_shifted[8:1], carry_out};

                if (cnt == 4'd8) begin
                    // Division complete
                    cnt <= 4'd0;
                    start_cnt <= 1'b0;

                    // Final remainder in SR[8:1], quotient in SR[0] and rest of quotient bits collected in each cycle
                    // Actually quotient is in bits [7:0] of SR after last iteration (bit0 and shifted in bits)
                    // At end of division, SR = {remainder[7:0], quotient[0]}
                    // But after shifts, quotient is in SR[7:0] and remainder in SR[8:1].

                    // Extract remainder and quotient
                    // Apply sign correction if signed division and operands negative

                    // Reconstruct quotient and remainder before sign fix:
                    reg [7:0] final_quotient;
                    reg [7:0] final_remainder;
                    final_remainder = SR[8:1];
                    final_quotient  = SR[7:0];

                    // Correct sign of quotient and remainder
                    if (sign) begin
                        // Quotient sign correction
                        if (quotient_sign)
                            final_quotient = (~final_quotient) + 1'b1;
                        // Remainder sign correction
                        if (remainder_sign)
                            final_remainder = (~final_remainder) + 1'b1;
                    end

                    // Pack result with remainder in upper 8 bits and quotient in lower 8 bits
                    result <= {final_remainder, final_quotient};

                    // If divisor was zero, output zero result and valid (or could indicate error - here zero result)
                    if (divisor_zero) begin
                        result <= 16'd0;
                    end

                    res_valid <= 1'b1;
                end else begin
                    // Continue counting
                    cnt <= cnt + 1'b1;
                end
            end else if (res_valid && !opn_valid) begin
                // Result consumed, clear res_valid
                res_valid <= 1'b0;
            end
        end
    end

endmodule