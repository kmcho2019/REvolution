module radix2_div (
    input           clk,
    input           rst,
    input           sign,          // 1: signed division, 0: unsigned
    input     [7:0] dividend,
    input     [7:0] divisor,
    input           opn_valid,
    output reg      res_valid,
    output reg [15:0] result        // {remainder[7:0], quotient[7:0]}
);

    // State registers
    reg [3:0] cnt;                 // iteration counter (0 to 8)
    reg start;                    // indicates active division operation

    // Registers to hold latched inputs/signs
    reg dividend_sign;
    reg divisor_sign;
    reg [7:0] dividend_abs;
    reg [7:0] divisor_abs;

    // Working registers for division
    reg [16:0] remainder;          // remainder shifted left + quotient bit, upper 17 bits for remainder and shift space
    reg [8:0]  divisor_9;          // 9-bit divisor (zero-extended)
    reg [7:0]  quotient;           // 8-bit quotient

    // Next-step wires
    reg [16:0] remainder_shifted;
    reg [16:0] remainder_sub;
    wire [16:0] divisor_shifted;   // divisor shifted for subtraction alignment (lower 9 bits)

    // Subtraction borrow logic (checking MSB after subtraction)
    wire subtraction_success;

    // Compute absolute values for signed inputs
    function [7:0] abs_val;
        input [7:0] val;
        input       s;
        begin
            if (s && val[7]) abs_val = (~val + 1'b1);
            else abs_val = val;
        end
    endfunction

    // Two's complement function for sign correction
    function [7:0] twos_comp;
        input [7:0] val;
        input       do_comp;
        begin
            if (do_comp) twos_comp = ~val + 1'b1;
            else twos_comp = val;
        end
    endfunction

    // divisor_9: divisor_abs zero-extended to 9 bits (upper bit 0)
    // We align divisor with upper bits of remainder for subtraction
    assign divisor_shifted = {divisor_9, 8'd0}; // divisor_9 left shifted by 8 bits to align with remainder MSBs

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            cnt          <= 0;
            start        <= 1'b0;
            res_valid    <= 1'b0;
            remainder    <= 17'd0;
            divisor_9    <= 9'd0;
            dividend_sign<= 1'b0;
            divisor_sign <= 1'b0;
            dividend_abs <= 8'd0;
            divisor_abs  <= 8'd0;
            quotient     <= 8'd0;
            result       <= 16'd0;
        end else begin
            if (!start) begin
                res_valid <= 1'b0; // clear result valid when not busy
                if (opn_valid && (divisor != 8'd0)) begin
                    // Latch inputs and calculate absolute values and signs
                    dividend_sign <= (sign && dividend[7]);
                    divisor_sign  <= (sign && divisor[7]);
                    dividend_abs  <= abs_val(dividend, sign);
                    divisor_abs   <= abs_val(divisor, sign);

                    divisor_9 <= {1'b0, abs_val(divisor, sign)}; // zero extend to 9 bits

                    // Initialize remainder: 17 bits with dividend_abs in bits [16:9] shifted left by 1 (to leave space for quotient bits)
                    // i.e. remainder = dividend_abs shifted left by 9+1 = 10 bits? Actually we keep dividend_abs in bits [16:9] and shift left by 1: 
                    // To match iterative algorithm:
                    // We start remainder = dividend_abs shifted left by 1 bit => remainder[16:9] = dividend_abs<<1
                    // Actually, the standard radix-2 division shifts dividend by 1 bit left, so:
                    // Let's assign: remainder[16:9] = dividend_abs shifted left by 1 = dividend_abs * 2
                    // The lower bits reserved for quotient being built step by step.
                    // So initialize remainder = {dividend_abs, 9'd0} << 1
                    remainder <= {dividend_abs, 9'd0} << 1;

                    quotient <= 8'd0;
                    cnt <= 4'd0;
                    start <= 1'b1;
                end
            end else begin
                // Iterative division step
                // 1. Shift remainder left by 1 bit (drop MSB, shift left)
                remainder_shifted = remainder << 1;

                // 2. Subtract divisor aligned in bits [16:8] from upper bits of remainder_shifted
                // divisor_9 is 9 bits, remainder_shifted upper 9 bits: remainder_shifted[16:8]
                remainder_sub = remainder_shifted;
                // subtraction: remainder_shifted[16:8] - divisor_9
                remainder_sub[16:8] = remainder_shifted[16:8] - divisor_9;

                // Check if subtraction success (remainder upper bits non-negative => MSB=0)
                subtraction_success = ~remainder_sub[16];

                if (subtraction_success) begin
                    // If subtraction ok, update remainder with remainder_sub, and set quotient LSB = 1
                    remainder <= remainder_sub;
                    quotient <= {quotient[6:0], 1'b1};
                end else begin
                    // Else keep remainder_shifted (without subtraction), quotient LSB = 0
                    remainder <= remainder_shifted;
                    quotient <= {quotient[6:0], 1'b0};
                end

                cnt <= cnt + 4'd1;

                if (cnt == 4'd7) begin
                    // After 8 iterations, finish division
                    start <= 1'b0;

                    // Extract remainder and quotient
                    // remainder is in remainder[16:9], which we right shift by 1 to get actual remainder value (since initially shifted left by 1)
                    // remainder[16:9] now represents remainder * 2 (because of initial shift)
                    // Divide by 2 by shifting right one to get actual remainder
                    // quotient is as computed

                    reg [7:0] raw_remainder;
                    reg [7:0] raw_quotient;
                    reg quotient_sign;
                    reg remainder_sign;
                    reg [7:0] quotient_final;
                    reg [7:0] remainder_final;

                    raw_remainder = remainder[16:9] >> 1;
                    raw_quotient = quotient;

                    quotient_sign = sign && (dividend_sign ^ divisor_sign);
                    remainder_sign = sign && dividend_sign;

                    // Apply sign correction by 2's complement if negative
                    quotient_final = quotient_sign ? (~raw_quotient + 1'b1) : raw_quotient;
                    remainder_final = remainder_sign ? (~raw_remainder + 1'b1) : raw_remainder;

                    result <= {remainder_final, quotient_final};
                    res_valid <= 1'b1;
                end
            end

            // Clear res_valid if new operation comes before reading result
            if (res_valid && opn_valid && !start)
                res_valid <= 1'b0;
        end
    end

endmodule