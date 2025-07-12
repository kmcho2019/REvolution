module radix2_div (
    input             clk,
    input             rst,
    input             sign,
    input      [7:0]  dividend,
    input      [7:0]  divisor,
    input             opn_valid,
    output reg        res_valid,
    output reg [15:0] result
);

    // Internal registers
    reg [16:0] SR;            // Shift register: combined remainder and quotient + 1 bit (17 bits)
    reg [8:0]  NEG_DIVISOR;   // Negated divisor absolute value, 9 bits (one extra bit for subtraction)
    reg [3:0]  cnt;           // 4-bit counter for 8 iterations (0..8)
    reg        start_cnt;     // Start signal for counting

    // Sign and absolute values
    reg [7:0] dividend_abs, divisor_abs;
    reg       dividend_neg, divisor_neg;
    reg       quotient_neg, remainder_neg;

    wire [8:0] sub_res;       // subtraction result: SR[16:8] - divisor_abs (9 bits)
    wire       sub_carry;     // carry flag from subtraction

    // --------------------
    // Absolute value logic
    function [7:0] abs8;
        input [7:0] val;
        begin
            if (sign && val[7])
                abs8 = (~val) + 1'b1;
            else
                abs8 = val;
        end
    endfunction

    // Initialize next sub_res (remainder high bits - divisor_abs)
    assign {sub_carry, sub_res} = {1'b0, SR[16:8]} + NEG_DIVISOR; // NEG_DIVISOR is negative divisor, addition instead of subtraction

    // Control logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset all registers and outputs
            SR            <= 17'd0;
            NEG_DIVISOR   <= 9'd0;
            cnt           <= 4'd0;
            start_cnt     <= 1'b0;
            res_valid     <= 1'b0;
            result        <= 16'd0;

            dividend_abs  <= 8'd0;
            divisor_abs   <= 8'd0;
            dividend_neg  <= 1'b0;
            divisor_neg   <= 1'b0;
            quotient_neg  <= 1'b0;
            remainder_neg <= 1'b0;
        end else begin
            if (opn_valid && !res_valid) begin
                // Capture inputs and initialize
                dividend_abs  <= abs8(dividend);
                divisor_abs   <= abs8(divisor);

                dividend_neg  <= sign ? dividend[7] : 1'b0;
                divisor_neg   <= sign ? divisor[7] : 1'b0;
                quotient_neg  <= sign ? (dividend[7] ^ divisor[7]) : 1'b0;
                remainder_neg <= sign ? dividend[7] : 1'b0;

                // Initialize SR: dividend_abs shifted left by 1 (append one zero bit at LSB)
                SR <= {dividend_abs, 1'b0};

                // NEG_DIVISOR = -divisor_abs extended to 9 bits for subtraction via addition
                // if divisor_abs=0, NEG_DIVISOR=0 (to avoid bad subtraction)
                NEG_DIVISOR <= divisor_abs != 8'd0 ? (~{1'b0, divisor_abs} + 1'b1) : 9'd0;

                cnt <= 4'd1;
                start_cnt <= 1'b1;
                res_valid <= 1'b0;
            end else if (start_cnt) begin
                if (cnt[3]) begin
                    // cnt MSB is set means cnt >= 8, division complete
                    cnt <= 4'd0;
                    start_cnt <= 1'b0;

                    // After completion, SR[16:9] = remainder, SR[8:1] = quotient (since we shift quotient bits in LSBs)
                    // Adjust signs if signed operation
                    // Extract remainder and quotient from SR
                    reg [7:0] remainder_out;
                    reg [7:0] quotient_out;

                    remainder_out = SR[16:9];
                    quotient_out  = SR[8:1];

                    if (sign) begin
                        // Apply sign to quotient (two's complement if negative)
                        if (quotient_neg)
                            quotient_out = (~quotient_out) + 1'b1;
                        // Apply sign to remainder
                        if (remainder_neg)
                            remainder_out = (~remainder_out) + 1'b1;
                    end

                    result <= {remainder_out, quotient_out};
                    res_valid <= 1'b1;

                end else begin
                    // Iteration step:
                    // Try subtraction: (SR[16:8] + NEG_DIVISOR)
                    if (sub_carry) begin
                        // sub_carry=1 means addition result >= 0 (no borrow), subtraction successful
                        // Update SR upper bits with subtraction result (sub_res)
                        // Shift SR left by 1 and append 1 to LSB (quotient bit)
                        SR <= {sub_res[7:0], SR[7:0], 1'b1};
                    end else begin
                        // subtraction failed: keep SR upper bits as is
                        // Shift SR left by 1 and append 0 to LSB (quotient bit)
                        SR <= {SR[15:0], 1'b0};
                    end
                    cnt <= cnt + 4'd1;
                end
            end else if (res_valid && !opn_valid) begin
                // Clear res_valid when result consumed (when opn_valid not asserted)
                res_valid <= 1'b0;
            end
        end
    end

endmodule