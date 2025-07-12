module radix2_div (
    input               clk,
    input               rst,
    input               sign,
    input       [7:0]   dividend,
    input       [7:0]   divisor,
    input               opn_valid,
    output reg          res_valid,
    output reg  [15:0]  result
);

    reg [7:0]  dividend_reg, divisor_reg;
    reg [7:0]  dividend_abs, divisor_abs;
    reg        dividend_neg, divisor_neg;
    reg        quotient_neg, remainder_neg;

    reg [16:0] SR;          // {remainder[8:0], quotient[7:0]}
    reg [8:0]  neg_divisor; // two's complement of divisor_abs extended to 9 bits
    reg [3:0]  cnt;
    reg        running;

    wire divisor_zero = (divisor == 8'd0);

    // Absolute values
    wire [7:0] divd_abs = (sign && dividend[7]) ? (~dividend + 1) : dividend;
    wire [7:0] divs_abs = (sign && divisor[7])  ? (~divisor  + 1) : divisor;

    // Extended remainder for subtraction: 9 bits upper part + 0 bit pad
    wire [9:0] rem_ext = {1'b0, SR[16:8]};
    wire [9:0] sub_res = rem_ext + neg_divisor; // remainder - divisor_abs
    wire sub_no_borrow = sub_res[9];            // 1 means remainder >= divisor

    reg [7:0] quotient_out, remainder_out;

    always @(posedge clk) begin
        if (rst) begin
            dividend_reg <= 0;
            divisor_reg  <= 0;
            dividend_abs <= 0;
            divisor_abs  <= 0;
            dividend_neg <= 0;
            divisor_neg  <= 0;
            quotient_neg <= 0;
            remainder_neg<= 0;
            SR           <= 0;
            neg_divisor  <= 0;
            cnt          <= 0;
            running      <= 0;
            res_valid    <= 0;
            result       <= 0;
            quotient_out <= 0;
            remainder_out<= 0;
        end else begin
            if (!running) begin
                res_valid <= 0;
                if (opn_valid) begin
                    dividend_reg <= dividend;
                    divisor_reg  <= divisor;

                    if (divisor_zero) begin
                        // Division by zero: output zero immediately
                        result    <= 16'd0;
                        res_valid <= 1'b1;
                    end else begin
                        // Compute absolute and sign flags
                        dividend_abs <= divd_abs;
                        divisor_abs  <= divs_abs;
                        dividend_neg <= (sign) ? dividend[7] : 0;
                        divisor_neg  <= (sign) ? divisor[7]  : 0;
                        quotient_neg <= (sign) ? (dividend[7] ^ divisor[7]) : 0;
                        remainder_neg<= (sign) ? dividend[7] : 0;

                        // Initialize shift register with dividend_abs shifted left by 1 bit (9-bit remainder) and zero quotient
                        SR <= {divd_abs, 1'b0, 8'd0};

                        // Two's complement of divisor_abs extended to 9 bits
                        neg_divisor <= (~{1'b0, divs_abs} + 9'd1);

                        cnt <= 4'd1;
                        running <= 1'b1;
                    end
                end
            end else begin
                // Division iterations
                if (cnt <= 8) begin
                    if (sub_no_borrow) begin
                        // remainder >= divisor: update remainder, shift in 1 to quotient
                        SR <= {sub_res[8:0], SR[7:0], 1'b1};
                    end else begin
                        // remainder < divisor: shift in 0 to quotient
                        SR <= {SR[15:0], 1'b0};
                    end
                    cnt <= cnt + 1;
                end else begin
                    // Division finished: apply sign corrections and output result
                    running <= 0;
                    res_valid <= 1;

                    quotient_out <= quotient_neg ? (~SR[7:0] + 8'd1) : SR[7:0];
                    remainder_out<= remainder_neg ? (~SR[16:9] + 8'd1) : SR[16:9];

                    result <= {remainder_out, quotient_out};
                end
            end

            // Clear res_valid when a new opn_valid comes after result is read
            if (res_valid && opn_valid && !running) begin
                res_valid <= 0;
            end
        end
    end
endmodule