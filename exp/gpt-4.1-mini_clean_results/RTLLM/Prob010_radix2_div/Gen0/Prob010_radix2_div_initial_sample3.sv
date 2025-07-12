module radix2_div (
    input           clk,
    input           rst,
    input           sign,           // 1: signed division, 0: unsigned
    input   [7:0]   dividend,
    input   [7:0]   divisor,
    input           opn_valid,
    output reg      res_valid,
    output reg [15:0] result          // {remainder[7:0], quotient[7:0]}
);

    // Internal registers
    reg [8:0] SR;          // Shift register: 9 bits (8 bits quotient + 1 bit extra)
    reg [7:0] NEG_DIVISOR; // Two's complement of divisor absolute value
    reg [3:0] cnt;         // Counter for 8 iterations
    reg start_cnt;         // Start signal for the division process
    reg dividend_sign;
    reg divisor_sign;
    reg [7:0] dividend_abs;
    reg [7:0] divisor_abs;

    // Registers to hold input operands for operation
    reg [7:0] dividend_reg;
    reg [7:0] divisor_reg;
    reg sign_reg;

    // For restoring final remainder and quotient signs
    reg [7:0] quotient;
    reg [7:0] remainder;

    // Subtraction result and carry out
    wire [8:0] sub_result;
    wire       sub_carry;

    // Extraction of upper 8 bits from SR for subtraction
    wire [8:0] sr_high = {SR[8], SR[7:1]};

    // Two's complement function for 8-bit value
    function [7:0] twos_comp;
        input [7:0] val;
        begin
            twos_comp = ~val + 1'b1;
        end
    endfunction

    // Absolute value and sign extraction
    // Using combinational logic to get abs and sign from dividend and divisor
    wire dividend_neg = sign && dividend[7];
    wire divisor_neg  = sign && divisor[7];

    wire [7:0] dividend_abs_w = dividend_neg ? twos_comp(dividend) : dividend;
    wire [7:0] divisor_abs_w  = divisor_neg  ? twos_comp(divisor)  : divisor;

    // Subtraction: sr_high + NEG_DIVISOR (NEG_DIVISOR is -divisor_abs)
    assign {sub_carry, sub_result} = sr_high + {1'b0, NEG_DIVISOR};

    // Division process sequential logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            res_valid   <= 1'b0;
            cnt         <= 4'd0;
            start_cnt   <= 1'b0;
            SR          <= 9'd0;
            NEG_DIVISOR <= 8'd0;
            dividend_reg<= 8'd0;
            divisor_reg <= 8'd0;
            sign_reg    <= 1'b0;
            quotient    <= 8'd0;
            remainder   <= 8'd0;
            dividend_abs<= 8'd0;
            divisor_abs <= 8'd0;
            dividend_sign <= 1'b0;
            divisor_sign  <= 1'b0;
        end else begin
            if (opn_valid && !res_valid) begin
                // Latch inputs and start division
                dividend_reg <= dividend;
                divisor_reg  <= divisor;
                sign_reg     <= sign;

                // Get abs values and signs
                dividend_abs <= dividend_neg ? twos_comp(dividend) : dividend;
                divisor_abs  <= divisor_neg  ? twos_comp(divisor)  : divisor;

                dividend_sign <= dividend_neg;
                divisor_sign  <= divisor_neg;

                // Initialize SR: {remainder(8 bits), quotient(8 bits)}, dividend shifted left by 1 bit (9 bits)
                // SR = (abs(dividend) << 1) = 9 bits: [8:0]
                SR <= {dividend_abs, 1'b0};

                // NEG_DIVISOR = -divisor_abs (8-bit two's complement)
                NEG_DIVISOR <= twos_comp(divisor_abs);

                cnt       <= 4'd1;
                start_cnt <= 1'b1;
                res_valid <= 1'b0;
            end else if (start_cnt) begin
                if (cnt == 4'd8) begin
                    // Division complete, finalize quotient and remainder
                    start_cnt <= 1'b0;
                    cnt       <= 4'd0;

                    // The remainder is in SR[8:1], quotient in SR[0] plus previously shifted quotient bits (stored in quotient reg below)
                    // But our SR updates keep quotient in SR[7:0] in LSB after each iteration

                    // Extract remainder = upper 8 bits of SR[8:1]
                    remainder <= SR[8:1];

                    // Extract quotient = lower 8 bits of SR[7:0]
                    quotient <= SR[7:0];

                    // After getting abs remainder and quotient, fix signs if signed division
                    // quotient sign = dividend_sign XOR divisor_sign
                    // remainder sign = dividend_sign
                    // Apply sign to quotient
                    if (sign_reg) begin
                        // Adjust quotient sign
                        if (dividend_sign ^ divisor_sign) begin
                            quotient <= twos_comp(quotient);
                        end
                        // Adjust remainder sign
                        if (dividend_sign) begin
                            remainder <= twos_comp(remainder);
                        end
                    end

                    // Compose result: remainder upper 8 bits, quotient lower 8 bits
                    result <= {remainder, quotient};
                    res_valid <= 1'b1;
                end else begin
                    // Perform subtraction step in the division iteration
                    if (sub_carry) begin
                        // If carry out = 1 means subtraction non-negative
                        // Update SR: shift left 1, insert 1 in LSB
                        SR <= {sub_result[7:0], 1'b1};
                    end else begin
                        // If subtraction negative, restore previous SR shifted left 1, insert 0 in LSB
                        SR <= {SR[7:0], 1'b0};
                    end
                    cnt <= cnt + 1'b1;
                end
            end else if (res_valid) begin
                // Wait for next opn_valid, keep res_valid high until consumed
                if (!opn_valid) begin
                    res_valid <= 1'b0;
                end
            end
        end
    end

endmodule