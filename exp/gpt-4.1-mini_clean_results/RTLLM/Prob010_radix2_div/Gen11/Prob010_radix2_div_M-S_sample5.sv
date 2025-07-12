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
    reg        dividend_neg, divisor_neg, quotient_neg, remainder_neg;
    reg [7:0]  dividend_abs, divisor_abs;
    reg [16:0] SR;          // [16:9] remainder (9 bits), [8:1] quotient, [0] unused for shift-in
    reg [8:0]  neg_divisor; // two's complement of divisor_abs extended 9 bits
    reg [3:0]  cnt;
    reg        busy;

    wire divisor_zero = (divisor_reg == 8'd0);

    // Compute absolute values and signs
    wire [7:0] dividend_abs_w = (sign && dividend_reg[7]) ? (~dividend_reg + 1) : dividend_reg;
    wire [7:0] divisor_abs_w  = (sign && divisor_reg[7])  ? (~divisor_reg  + 1) : divisor_reg;

    // Subtraction: remainder - divisor_abs
    wire [9:0] remainder_ext = {1'b0, SR[16:8]}; // 9 bits remainder extended
    wire [9:0] sub_res = remainder_ext + neg_divisor; // remainder - divisor_abs (neg_divisor = -divisor_abs)
    wire       no_borrow = ~sub_res[9]; // borrow = sub_res[9], so no borrow when zero

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            dividend_reg <= 0;
            divisor_reg <= 0;
            dividend_abs <= 0;
            divisor_abs <= 0;
            dividend_neg <= 0;
            divisor_neg <= 0;
            quotient_neg <= 0;
            remainder_neg <= 0;
            SR <= 0;
            neg_divisor <= 0;
            cnt <= 0;
            busy <= 0;
            res_valid <= 0;
            result <= 0;
        end else begin
            if (!busy && opn_valid && !res_valid) begin
                // Load inputs and prepare for division
                dividend_reg <= dividend;
                divisor_reg <= divisor;
                dividend_abs <= dividend_abs_w;
                divisor_abs <= divisor_abs_w;
                dividend_neg <= sign && dividend[7];
                divisor_neg <= sign && divisor[7];
                quotient_neg <= sign && (dividend[7] ^ divisor[7]);
                remainder_neg <= sign && dividend[7];
                // Initialize SR: remainder = dividend_abs shifted left by 1 bit in upper 9 bits, quotient = 0
                SR <= {dividend_abs_w, 1'b0, 8'd0};
                neg_divisor <= (~{1'b0, divisor_abs_w} + 9'd1);
                cnt <= 1;
                busy <= 1;
                res_valid <= 0;
            end else if (busy) begin
                if (divisor_zero) begin
                    // Division by zero: output zero immediately
                    result <= 16'd0;
                    res_valid <= 1'b1;
                    busy <= 0;
                    cnt <= 0;
                end else if (cnt <= 8) begin
                    if (no_borrow) begin
                        // remainder >= divisor: update remainder and set quotient bit
                        SR <= {sub_res[8:0], SR[7:0], 1'b1};
                    end else begin
                        // remainder < divisor: shift left, quotient bit=0
                        SR <= {SR[15:0], 1'b0};
                    end
                    cnt <= cnt + 1;
                end else begin
                    // Division done: apply sign corrections
                    reg [7:0] q, r;
                    q = quotient_neg ? (~SR[7:0] + 1) : SR[7:0];
                    r = remainder_neg ? (~SR[16:9] + 1) : SR[16:9];
                    result <= {r, q};
                    res_valid <= 1'b1;
                    busy <= 0;
                    cnt <= 0;
                end
            end else if (res_valid && !opn_valid) begin
                // Clear valid flag when new operation allowed
                res_valid <= 0;
            end
        end
    end
endmodule