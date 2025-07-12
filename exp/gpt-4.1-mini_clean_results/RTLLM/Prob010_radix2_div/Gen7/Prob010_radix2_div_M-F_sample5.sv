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
    reg active;             // Indicates division is in progress
    reg [3:0] cnt;          // Iteration counter 0..8
    reg dividend_sign, divisor_sign;
    reg quotient_sign, remainder_sign;
    reg [7:0] dividend_abs;
    reg [7:0] divisor_abs;

    // 17-bit shift register: [16:8] remainder(9 bits), [7:0] quotient(8 bits)
    reg [16:0] shift_reg;

    // Temporary variables for sign correction and outputs
    reg [7:0] q_sat;
    reg [7:0] r_sat;
    reg [7:0] raw_quotient;
    reg [7:0] raw_remainder;

    // Compute absolute values combinationally
    wire [7:0] dividend_abs_c;
    wire [7:0] divisor_abs_c;

    assign dividend_abs_c = (sign && dividend[7]) ? (~dividend + 8'd1) : dividend;
    assign divisor_abs_c  = (sign && divisor[7])  ? (~divisor  + 8'd1) : divisor;

    // Subtraction: remainder - divisor_abs
    wire [8:0] remainder = shift_reg[16:8];
    wire [8:0] divisor_ext = {1'b0, divisor_abs};
    wire [8:0] sub_res = remainder - divisor_ext;
    wire sub_res_nonneg = ~sub_res[8]; // MSB=0 means >=0

    // Next step shift_reg logic
    wire [16:0] shift_reg_next_sub; // if subtraction non-negative
    wire [16:0] shift_reg_next_no_sub; // if subtraction negative

    // If subtraction non-negative:
    // remainder = sub_res[7:0], quotient append 1 at LSB after shift left
    // shift left by 1: {remainder, quotient} << 1 plus 1 at LSB
    assign shift_reg_next_sub = {sub_res[7:0], shift_reg[7:0], 1'b1};

    // If subtraction negative:
    // remainder unchanged, quotient shift left, append 0
    assign shift_reg_next_no_sub = {shift_reg[15:0], 1'b0};

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            active         <= 1'b0;
            res_valid      <= 1'b0;
            result         <= 16'd0;
            cnt            <= 4'd0;

            dividend_sign  <= 1'b0;
            divisor_sign   <= 1'b0;
            quotient_sign  <= 1'b0;
            remainder_sign <= 1'b0;

            dividend_abs   <= 8'd0;
            divisor_abs    <= 8'd0;
            shift_reg      <= 17'd0;

            q_sat          <= 8'd0;
            r_sat          <= 8'd0;
            raw_quotient   <= 8'd0;
            raw_remainder  <= 8'd0;
        end else begin
            if (opn_valid && !active && !res_valid) begin
                // Start new division
                active         <= 1'b1;
                cnt            <= 4'd0;

                // Capture signs
                dividend_sign  <= sign ? dividend[7] : 1'b0;
                divisor_sign   <= sign ? divisor[7]  : 1'b0;
                quotient_sign  <= sign ? (dividend[7] ^ divisor[7]) : 1'b0;
                remainder_sign <= sign ? dividend[7] : 1'b0;

                // Latch absolute values
                dividend_abs   <= dividend_abs_c;
                divisor_abs    <= divisor_abs_c;

                // Initialize shift register: remainder = dividend_abs shifted left by 1 bit (to make 9 bits),
                // quotient = 0
                // That is, shift_reg[16:9] = dividend_abs, shift_reg[8] = 0, shift_reg[7:0] = 0
                shift_reg      <= {dividend_abs_c, 1'b0, 8'd0};

                res_valid      <= 1'b0;
                result         <= 16'd0;
            end else if (active) begin
                if (divisor_abs == 8'd0) begin
                    // Division by zero: quotient = all 1's, remainder = dividend_abs
                    // We will finish division immediately
                    active    <= 1'b0;
                    res_valid <= 1'b1;

                    // Saturate quotient
                    q_sat <= 8'hFF;
                    r_sat <= dividend_abs;

                    // Apply sign corrections on quotient and remainder
                    if (sign && quotient_sign)
                        q_sat <= (~8'hFF) + 8'd1; // -255 not representable in 8 bits, but this is saturated max negative (2's comp)
                    if (sign && remainder_sign)
                        r_sat <= (~dividend_abs) + 8'd1;

                    // Compose result
                    result <= {r_sat, q_sat};
                end else if (cnt == 4'd8) begin
                    // Division finished
                    active <= 1'b0;
                    res_valid <= 1'b1;

                    // Extract raw quotient and remainder
                    raw_quotient  <= shift_reg[7:0];
                    raw_remainder <= shift_reg[16:9];

                    // Apply sign correction
                    if (sign && quotient_sign)
                        raw_quotient <= ~shift_reg[7:0] + 8'd1;
                    else
                        raw_quotient <= shift_reg[7:0];

                    if (sign && remainder_sign)
                        raw_remainder <= ~shift_reg[16:9] + 8'd1;
                    else
                        raw_remainder <= shift_reg[16:9];

                    result <= {raw_remainder, raw_quotient};
                end else begin
                    // Division ongoing: perform one iteration of radix-2 division step
                    cnt <= cnt + 4'd1;

                    if (sub_res_nonneg) begin
                        // Update shift register with subtraction result and quotient bit set to 1
                        shift_reg <= shift_reg_next_sub;
                    end else begin
                        // No subtraction, quotient bit set to 0
                        shift_reg <= shift_reg_next_no_sub;
                    end
                end
            end else if (res_valid) begin
                // Wait for new operation or reset to clear res_valid
                if (!opn_valid) begin
                    res_valid <= 1'b0;
                end
            end
        end
    end

endmodule