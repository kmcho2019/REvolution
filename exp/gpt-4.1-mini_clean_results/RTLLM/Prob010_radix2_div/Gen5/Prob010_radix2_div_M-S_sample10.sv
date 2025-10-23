module radix2_div(
    input              clk,
    input              rst,
    input              sign,             // 1 = signed division, 0 = unsigned
    input      [7:0]   dividend,
    input      [7:0]   divisor,
    input              opn_valid,
    output reg         res_valid,
    output reg [15:0]  result            // {remainder[7:0], quotient[7:0]}
);

    reg [7:0] dividend_reg, divisor_reg;
    reg       sign_quotient, sign_remainder;
    reg [7:0] dividend_abs, divisor_abs;

    reg [16:0] SR;  // {remainder[8:0], quotient[7:0]} - remainder is 9 bits
    reg [3:0]  cnt;
    reg        running;

    wire [8:0] remainder = SR[16:8];
    wire [9:0] sub_res = {1'b0, remainder} - {1'b0, divisor_abs};
    wire       borrow = sub_res[9];
    wire [8:0] remainder_next = borrow ? remainder : sub_res[8:0];
    wire       qbit = borrow ? 1'b0 : 1'b1;

    // Calculate absolute values and quotient/remainder signs
    wire dividend_neg = sign && dividend[7];
    wire divisor_neg  = sign && divisor[7];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            res_valid <= 1'b0;
            running <= 1'b0;
            cnt <= 0;
            SR <= 0;
            dividend_reg <= 0;
            divisor_reg <= 0;
            dividend_abs <= 0;
            divisor_abs <= 0;
            sign_quotient <= 0;
            sign_remainder <= 0;
            result <= 0;
        end else begin
            if (!running) begin
                res_valid <= 1'b0;
                if (opn_valid) begin
                    // Latch inputs
                    dividend_reg <= dividend;
                    divisor_reg <= divisor;
                    sign_quotient <= dividend_neg ^ divisor_neg;
                    sign_remainder <= dividend_neg;

                    // Absolute values
                    dividend_abs <= dividend_neg ? (~dividend + 1'b1) : dividend;
                    divisor_abs <= divisor_neg ? (~divisor + 1'b1) : divisor;

                    // Initialize shift register:
                    // remainder = dividend_abs shifted left by 1 bit (9 bits),
                    // quotient = 0
                    SR <= {dividend_neg ? (~dividend_abs + 1'b1) : dividend_abs, 1'b0, 8'b0};
                    // Note: Use positive dividend_abs shifted left 1 for remainder, quotient zero

                    // Actually, remainder must be absolute value, so just {dividend_abs,1'b0}
                    // The sign handling is done after division is complete

                    SR <= {dividend_abs, 1'b0, 8'b0};

                    cnt <= 0;
                    running <= 1'b1;
                end
            end else begin
                // Running division steps
                cnt <= cnt + 1'b1;

                // Update SR:
                // Shift remainder and quotient left by 1, insert qbit at quotient LSB
                SR <= {remainder_next, SR[7:1], qbit};

                if (cnt == 4'd7) begin
                    // Done after 8 cycles (cnt from 0 to 7)
                    running <= 1'b0;
                    res_valid <= 1'b1;

                    // Correct signs of quotient and remainder
                    // Extract quotient and remainder:
                    // remainder is 9 bits; discard LSB (from initial left shift)
                    // remainder output = remainder[8:1]
                    // quotient output = SR[7:0]

                    // Handle quotient sign
                    // If signed and sign_quotient==1, negate quotient
                    // Handle remainder sign similarly

                    reg [7:0] q_out;
                    reg [7:0] r_out;

                    q_out = SR[7:0];
                    r_out = remainder_next[8:1];

                    if (sign && sign_quotient)
                        q_out = ~q_out + 1'b1;
                    if (sign && sign_remainder)
                        r_out = ~r_out + 1'b1;

                    result <= {r_out, q_out};
                end
            end

            // Clear res_valid when new opn_valid and not running
            if (res_valid && opn_valid && !running)
                res_valid <= 1'b0;
        end
    end

endmodule