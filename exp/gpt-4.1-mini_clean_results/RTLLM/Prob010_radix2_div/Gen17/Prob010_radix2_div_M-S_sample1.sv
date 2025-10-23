module radix2_div (
    input               clk,
    input               rst,
    input               sign,           // 1: signed division, 0: unsigned
    input       [7:0]   dividend,
    input       [7:0]   divisor,
    input               opn_valid,
    output reg          res_valid,
    output reg  [15:0]  result          // [15:8] remainder, [7:0] quotient
);

    // State encoding
    localparam IDLE = 1'b0, DIVIDE = 1'b1;
    reg state, next_state;

    reg [3:0] cnt;              // iteration counter 0..8
    reg [16:0] SR;              // {remainder[8:0], quotient[7:0]}
    reg [8:0] divisor_abs;      // absolute divisor (9 bits)
    reg [7:0] dividend_abs;     // absolute dividend (8 bits)
    reg dividend_neg, divisor_neg;
    reg quotient_neg, remainder_neg;
    reg op_start;

    wire divisor_zero = (divisor_abs == 9'd0);

    // Compute absolute values inline
    wire [7:0] divd_abs_w = (sign && dividend[7]) ? (~dividend + 8'd1) : dividend;
    wire [8:0] divs_abs_w = (sign && divisor[7]) ? {1'b0, (~divisor + 8'd1)} : {1'b0, divisor};

    // Subtraction result: remainder part - divisor_abs
    wire signed [9:0] rem_part = {1'b0, SR[16:8]};
    wire signed [9:0] sub_res = rem_part - {1'b0, divisor_abs};

    // Next state logic and combinational updates
    reg [16:0] SR_next;
    reg [3:0] cnt_next;

    always @(*) begin
        next_state = state;
        SR_next = SR;
        cnt_next = cnt;

        case(state)
            IDLE: begin
                if (opn_valid && !res_valid)
                    next_state = DIVIDE;
            end
            DIVIDE: begin
                if (cnt == 4'd8)
                    next_state = IDLE;
                else
                    next_state = DIVIDE;

                if (divisor_zero) begin
                    // special case: divisor=0 => quotient=0, remainder=dividend
                    SR_next = { {dividend_abs,1'b0}, 8'd0 };
                    cnt_next = 4'd8;
                end else begin
                    // shift left SR by 1
                    SR_next = { SR[15:0], 1'b0 };
                    cnt_next = cnt + 1'b1;
                    if (sub_res >= 0) begin
                        // subtraction successful
                        SR_next[16:8] = sub_res[8:0];
                        SR_next[0] = 1'b1; // set quotient bit
                    end
                end
            end
        endcase
    end

    // Sequential logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            res_valid <= 1'b0;
            result <= 16'd0;
            cnt <= 4'd0;
            SR <= 17'd0;
            divisor_abs <= 9'd0;
            dividend_abs <= 8'd0;
            dividend_neg <= 1'b0;
            divisor_neg <= 1'b0;
            quotient_neg <= 1'b0;
            remainder_neg <= 1'b0;
            op_start <= 1'b0;
        end else begin
            state <= next_state;
            case(state)
                IDLE: begin
                    res_valid <= 1'b0;
                    if (opn_valid && !res_valid && !op_start) begin
                        dividend_neg <= (sign && dividend[7]);
                        divisor_neg <= (sign && divisor[7]);
                        dividend_abs <= divd_abs_w;
                        divisor_abs <= divs_abs_w;
                        quotient_neg <= (sign && (dividend[7] ^ divisor[7]));
                        remainder_neg <= (sign && dividend[7]);
                        // Initialize SR: remainder = dividend_abs shifted left by 1 (9 bits), quotient=0
                        SR <= {dividend_abs, 1'b0, 8'd0};
                        cnt <= 4'd0;
                        op_start <= 1'b1;
                    end else if (!opn_valid) begin
                        op_start <= 1'b0;
                    end
                end
                DIVIDE: begin
                    SR <= SR_next;
                    cnt <= cnt_next;
                    if (cnt_next == 4'd8) begin
                        res_valid <= 1'b1;
                    end
                end
            endcase

            // When res_valid and a new operation starts, clear res_valid
            if (res_valid && opn_valid)
                res_valid <= 1'b0;
        end
    end

    // Sign correction for quotient and remainder
    wire [7:0] quotient_raw = SR[7:0];
    wire [7:0] remainder_raw = SR[16:9];

    wire [7:0] quotient_out = quotient_neg ? (~quotient_raw + 8'd1) : quotient_raw;
    wire [7:0] remainder_out = remainder_neg ? (~remainder_raw + 8'd1) : remainder_raw;

    always @(posedge clk) begin
        if (res_valid) begin
            result <= { remainder_out, quotient_out };
        end
    end

endmodule