module radix2_div (
    input             clk,
    input             rst,
    input             sign,           // 1: signed, 0: unsigned
    input      [7:0]  dividend,
    input      [7:0]  divisor,
    input             opn_valid,
    output reg        res_valid,
    output reg [15:0] result           // [15:8] remainder, [7:0] quotient
);

    localparam IDLE = 1'b0;
    localparam RUN  = 1'b1;

    reg state;
    reg [3:0] cnt;           // iteration counter 0..8
    reg dividend_neg, divisor_neg;
    reg quotient_neg, remainder_neg;

    reg [8:0] divisor_abs;   // 9 bits for abs divisor (extend 8->9)
    reg [7:0] dividend_abs;  // 8 bits abs dividend

    reg [16:0] SR;           // {9'b remainder, 8'b quotient}, one extra bit for shifting

    wire divisor_is_zero = (divisor_abs == 9'd0);

    // Compute absolute values inline
    wire [7:0] dividend_abs_w = (sign && dividend[7]) ? (~dividend + 8'd1) : dividend;
    wire [8:0] divisor_abs_w  = (sign && divisor[7]) ? {1'b0, (~divisor + 8'd1)} : {1'b0, divisor};

    // Subtraction of divisor_abs from remainder part (upper 9 bits)
    wire signed [9:0] remainder_part = {1'b0, SR[16:8]};
    wire signed [9:0] sub_res = remainder_part - divisor_abs;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            res_valid <= 1'b0;
            result <= 16'd0;
            cnt <= 4'd0;
            SR <= 17'd0;
            dividend_neg <= 1'b0;
            divisor_neg <= 1'b0;
            quotient_neg <= 1'b0;
            remainder_neg <= 1'b0;
            divisor_abs <= 9'd0;
            dividend_abs <= 8'd0;
        end else begin
            case(state)
                IDLE: begin
                    res_valid <= 1'b0;
                    if (opn_valid) begin
                        // Capture sign bits and abs values
                        dividend_neg <= (sign && dividend[7]);
                        divisor_neg <= (sign && divisor[7]);

                        dividend_abs <= dividend_abs_w;
                        divisor_abs <= divisor_abs_w;

                        quotient_neg <= (sign && (dividend[7] ^ divisor[7]));
                        remainder_neg <= (sign && dividend[7]);

                        // Initialize SR with dividend_abs shifted left 1 bit in remainder part, quotient zero
                        // SR layout: remainder(9 bits) | quotient(8 bits)
                        // remainder initialized as dividend_abs shifted left by 1 (LSB zero)
                        SR <= {dividend_abs, 1'b0, 8'd0};
                        cnt <= 4'd0;

                        state <= RUN;
                    end
                end

                RUN: begin
                    if (divisor_is_zero) begin
                        // Division by zero: quotient=0, remainder=dividend_abs (with sign correction later)
                        SR <= {dividend_abs, 8'd0};
                        cnt <= 4'd8; // finish iterations immediately
                    end else if (cnt < 4'd8) begin
                        // Shift SR left by 1
                        // After shift, attempt subtraction
                        // If subtraction result >= 0: update remainder with sub_res and set quotient LSB=1
                        // else: keep remainder, quotient LSB=0
                        // Shift left 1:
                        // SR[15:0] << 1, bit0 zero, then modify if sub_res >=0

                        // Prepare shifted value
                        // We will construct next SR here:
                        reg [16:0] SR_shift;
                        reg sub_ok;
                        begin
                            SR_shift = {SR[15:0], 1'b0};
                            sub_ok = (sub_res >= 0);
                            if (sub_ok) begin
                                // update remainder part [16:8]
                                SR_shift[16:8] = sub_res[8:0];
                                SR_shift[0] = 1'b1;
                            end
                            SR <= SR_shift;
                        end

                        cnt <= cnt + 1'b1;
                    end else begin
                        // Iterations complete: output result with sign correction
                        // Extract raw quotient and remainder
                        reg [7:0] quotient_raw;
                        reg [7:0] remainder_raw;
                        reg [7:0] quotient_signed;
                        reg [7:0] remainder_signed;

                        quotient_raw = SR[7:0];
                        remainder_raw = SR[16:9];

                        // Apply sign corrections
                        quotient_signed = quotient_neg ? (~quotient_raw + 1) : quotient_raw;
                        remainder_signed = remainder_neg ? (~remainder_raw + 1) : remainder_raw;

                        result <= {remainder_signed, quotient_signed};
                        res_valid <= 1'b1;
                        state <= IDLE;
                    end
                end

                default: state <= IDLE;
            endcase

            // Clear res_valid when new operation starts
            if (state == IDLE && opn_valid) begin
                res_valid <= 1'b0;
            end
        end
    end

endmodule