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

    // Registers to hold inputs and intermediate values
    reg [7:0]  dividend_reg;
    reg [7:0]  divisor_reg;

    reg [7:0]  dividend_abs;
    reg [7:0]  divisor_abs;

    reg        dividend_neg;
    reg        divisor_neg;
    reg        quotient_neg;
    reg        remainder_neg;

    reg [16:0] SR;          // Shift register: remainder(9 bits) + quotient(8 bits)
    reg [8:0]  neg_divisor; // 9-bit two's complement of divisor_abs
    reg [3:0]  cnt;         // counter from 0 to 8
    reg        running;     // division in progress

    wire divisor_zero = (divisor == 8'd0);

    // Combinational absolute value calculation
    wire [7:0] dividend_abs_comb = (sign && dividend[7]) ? (~dividend + 8'd1) : dividend;
    wire [7:0] divisor_abs_comb  = (sign && divisor[7])  ? (~divisor  + 8'd1) : divisor;

    // Extended remainder for subtraction (9 bits upper part of SR + zero)
    wire [9:0] remainder_ext = {1'b0, SR[16:8]};
    wire [9:0] sub_res = remainder_ext + neg_divisor; // remainder - divisor_abs
    wire sub_no_borrow = sub_res[9]; // If 1, no borrow (remainder >= divisor)

    // Registers to hold output after sign correction
    reg [7:0] quotient_out;
    reg [7:0] remainder_out;

    always @(posedge clk) begin
        if (rst) begin
            dividend_reg   <= 8'd0;
            divisor_reg    <= 8'd0;
            dividend_abs   <= 8'd0;
            divisor_abs    <= 8'd0;
            dividend_neg   <= 1'b0;
            divisor_neg    <= 1'b0;
            quotient_neg   <= 1'b0;
            remainder_neg  <= 1'b0;
            SR             <= 17'd0;
            neg_divisor    <= 9'd0;
            cnt            <= 4'd0;
            running        <= 1'b0;
            res_valid      <= 1'b0;
            result         <= 16'd0;
            quotient_out   <= 8'd0;
            remainder_out  <= 8'd0;
        end else begin
            if (!running) begin
                res_valid <= 1'b0;
                if (opn_valid && !res_valid) begin
                    dividend_reg <= dividend;
                    divisor_reg  <= divisor;

                    if (divisor_zero) begin
                        // Division by zero: output zero immediately
                        result    <= 16'd0;
                        res_valid <= 1'b1;
                        running   <= 1'b0;
                        cnt       <= 4'd0;
                    end else begin
                        // Capture absolute values and signs for signed division
                        dividend_abs  <= dividend_abs_comb;
                        divisor_abs   <= divisor_abs_comb;

                        dividend_neg  <= (sign) ? dividend[7] : 1'b0;
                        divisor_neg   <= (sign) ? divisor[7]  : 1'b0;
                        quotient_neg  <= (sign) ? (dividend[7] ^ divisor[7]) : 1'b0;
                        remainder_neg <= (sign) ? dividend[7] : 1'b0;

                        // Initialize SR: remainder = dividend_abs << 1 (9 bits), quotient = 0
                        SR <= {dividend_abs_comb, 1'b0, 8'd0};

                        // neg_divisor = two's complement of divisor_abs extended to 9 bits
                        neg_divisor <= (~{1'b0, divisor_abs_comb} + 9'd1);

                        cnt <= 4'd1;
                        running <= 1'b1;
                    end
                end
            end else begin
                // Division in progress
                if (cnt <= 8) begin
                    if (sub_no_borrow) begin
                        // remainder >= divisor: update remainder to sub_res[8:0], shift quotient in 1
                        SR <= {sub_res[8:0], SR[7:0], 1'b1};
                    end else begin
                        // remainder < divisor: shift left and quotient in 0
                        SR <= {SR[15:0], 1'b0};
                    end
                    cnt <= cnt + 4'd1;
                end else begin
                    // Division complete: apply sign correction and output result
                    running <= 1'b0;
                    res_valid <= 1'b1;

                    // Extract quotient (bits [7:0]) and remainder (bits [16:9])
                    if (quotient_neg)
                        quotient_out <= (~SR[7:0]) + 8'd1;
                    else
                        quotient_out <= SR[7:0];

                    if (remainder_neg)
                        remainder_out <= (~SR[16:9]) + 8'd1;
                    else
                        remainder_out <= SR[16:9];

                    result <= {remainder_out, quotient_out};
                end
            end

            // Clear res_valid if new opn_valid and division not running to allow new operation
            if (res_valid && opn_valid && !running) begin
                res_valid <= 1'b0;
            end
        end
    end

endmodule