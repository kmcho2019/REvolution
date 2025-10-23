module radix2_div (
    input           clk,
    input           rst,
    input           sign,
    input   [7:0]   dividend,
    input   [7:0]   divisor,
    input           opn_valid,
    output  reg     res_valid,
    output  reg [15:0] result
);

    // Internal registers and wires
    reg [8:0] SR;              // Shift register: 9 bits to hold remainder and quotient bits during division
    reg [8:0] NEG_DIVISOR;     // Negated divisor absolute value with one extra bit for subtraction
    reg [3:0] cnt;             // 4-bit counter for division steps (max 8)
    reg start_cnt;             // Start signal to enable division iterations

    // Registers to hold inputs latched
    reg [7:0] dividend_r;
    reg [7:0] divisor_r;
    reg sign_r;

    // Internal absolute values and sign flags
    reg [7:0] dividend_abs;
    reg [7:0] divisor_abs;

    reg dividend_sign;
    reg divisor_sign;

    // Quotient and remainder sign for final result adjustment
    reg quotient_sign;
    reg remainder_sign;

    // Temporary subtraction result
    wire [8:0] sub_res;
    wire       sub_carry;  // carry-out from subtraction

    // Temporary registers for final quotient and remainder before packing result
    reg [7:0] quotient_abs;
    reg [7:0] remainder_abs;
    reg [7:0] quotient_final;
    reg [7:0] remainder_final;

    // Compute absolute values and signs (combinational)
    always @(*) begin
        if (sign_r) begin
            dividend_sign = dividend_r[7];
            divisor_sign  = divisor_r[7];
            dividend_abs  = dividend_sign ? (~dividend_r + 1'b1) : dividend_r;
            divisor_abs   = divisor_sign  ? (~divisor_r  + 1'b1) : divisor_r;
        end else begin
            dividend_sign = 1'b0;
            divisor_sign  = 1'b0;
            dividend_abs  = dividend_r;
            divisor_abs   = divisor_r;
        end
        quotient_sign = dividend_sign ^ divisor_sign;
        remainder_sign = dividend_sign;
    end

    // NEG_DIVISOR = 2's complement of divisor_abs extended to 9 bits
    always @(*) begin
        NEG_DIVISOR = {1'b0, ~divisor_abs} + 9'd1;
    end

    // Subtraction: SR + NEG_DIVISOR (which is SR - divisor_abs)
    assign {sub_carry, sub_res} = SR + NEG_DIVISOR;

    // Main sequential process
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset all state
            SR <= 9'd0;
            NEG_DIVISOR <= 9'd0;
            cnt <= 4'd0;
            start_cnt <= 1'b0;
            dividend_r <= 8'd0;
            divisor_r <= 8'd0;
            sign_r <= 1'b0;
            res_valid <= 1'b0;
            result <= 16'd0;

            quotient_abs <= 8'd0;
            remainder_abs <= 8'd0;
            quotient_final <= 8'd0;
            remainder_final <= 8'd0;
        end else begin
            if (opn_valid && !res_valid && !start_cnt) begin
                // Latch inputs and start operation
                dividend_r <= dividend;
                divisor_r <= divisor;
                sign_r <= sign;

                // Prepare shift register: dividend_abs shifted left by 1 bit (9 bits)
                SR <= {dividend_abs, 1'b0};

                cnt <= 4'd1;
                start_cnt <= 1'b1;
                res_valid <= 1'b0;

                // Clear temp registers
                quotient_abs <= 8'd0;
                remainder_abs <= 8'd0;
                quotient_final <= 8'd0;
                remainder_final <= 8'd0;

            end else if (start_cnt) begin
                // Division iterations
                if (cnt[3]) begin
                    // cnt[3] = 1 means cnt >= 8, division finished
                    start_cnt <= 1'b0;
                    cnt <= 4'd0;

                    // Extract quotient and remainder abs from SR
                    quotient_abs <= SR[7:0];
                    remainder_abs <= SR[8:1];

                    // Adjust signs
                    if (sign_r && remainder_sign && (SR[8:1] != 8'd0))
                        remainder_final <= (~SR[8:1] + 1'b1);
                    else
                        remainder_final <= SR[8:1];

                    if (sign_r && quotient_sign && (SR[7:0] != 8'd0))
                        quotient_final <= (~SR[7:0] + 1'b1);
                    else
                        quotient_final <= SR[7:0];

                    // Pack result
                    result <= {remainder_final, quotient_final};
                    res_valid <= 1'b1;

                end else begin
                    // Perform next iteration
                    cnt <= cnt + 4'd1;

                    // If no borrow in subtraction, update SR with sub_res and set bit0=1
                    // else shift SR left with bit0=0
                    if (sub_carry) begin
                        SR <= {sub_res[7:0], 1'b1};
                    end else begin
                        SR <= {SR[7:0], 1'b0};
                    end
                end
            end else if (res_valid) begin
                // Keep result valid until next op starts
                if (opn_valid) begin
                    res_valid <= 1'b0;
                end
            end
        end
    end

endmodule