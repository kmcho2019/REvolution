module radix2_div(
    input              clk,
    input              rst,
    input              sign,           // 1 for signed division, 0 for unsigned
    input      [7:0]   dividend,
    input      [7:0]   divisor,
    input              opn_valid,
    output reg         res_valid,
    output reg [15:0]  result           // {remainder[7:0], quotient[7:0]}
);

    // State machine states
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        CALC = 2'b01,
        DONE = 2'b10
    } state_t;
    state_t state, next_state;

    reg [3:0] cnt;

    // Internal registers for absolute values and signs
    reg [7:0] dividend_abs;
    reg [7:0] divisor_abs;
    reg       dividend_neg;
    reg       divisor_neg;
    reg       sign_quotient;
    reg       sign_remainder;

    // Shift register: [16:8] remainder (9 bits), [7:0] quotient (8 bits)
    reg [16:0] SR;

    // Combinational wires for subtraction
    wire [8:0] remainder_part = SR[16:8];
    wire [8:0] sub_res;
    wire       borrow;

    assign {borrow, sub_res} = {1'b0, remainder_part} - {1'b0, divisor_abs};

    // Next SR after iteration
    wire [16:0] SR_next = borrow ?
                          // borrow=1 means remainder < divisor_abs, no subtraction
                          {remainder_part, SR[7:1], 1'b0} << 1 | 1'b0 :
                          // borrow=0 means subtraction succeeded, set quotient bit to 1
                          {sub_res, SR[7:1], 1'b1} << 1 | 1'b0;

    // However, shifting twice is wrong; we must do shift left by 1, then decide quotient bit
    // So rewrite logic to avoid double shift:

    // After left shift by 1 (SR <<1), remainder part is one bit higher shifted; so must update properly:

    // Actually, per iteration:
    // 1) Shift SR left by 1 bit (SR_shift = SR << 1)
    // 2) Try subtract divisor_abs from SR_shift[16:8]
    // 3) If no borrow, update remainder with subtraction result and set quotient LSB to 1
    //    Else keep remainder as is and quotient bit 0.

    // So we implement as:
    wire [16:0] SR_shift = {SR[15:0], 1'b0};
    wire [8:0] remainder_shifted = SR_shift[16:8];
    wire borrow_shift;
    wire [8:0] sub_res_shift;

    assign {borrow_shift, sub_res_shift} = {1'b0, remainder_shifted} - {1'b0, divisor_abs};

    wire [16:0] SR_iter_next = borrow_shift ?
                              {remainder_shifted, SR_shift[7:1], 1'b0} :
                              {sub_res_shift,   SR_shift[7:1], 1'b1};

    // State machine sequential logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state         <= IDLE;
            SR            <= 17'd0;
            cnt           <= 4'd0;
            dividend_abs  <= 8'd0;
            divisor_abs   <= 8'd0;
            dividend_neg  <= 1'b0;
            divisor_neg   <= 1'b0;
            sign_quotient <= 1'b0;
            sign_remainder<= 1'b0;
            res_valid     <= 1'b0;
            result        <= 16'd0;
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin
                    res_valid <= 1'b0;
                    cnt <= 4'd0;
                    if (opn_valid) begin
                        // Calculate abs and signs
                        if (sign) begin
                            dividend_neg  <= dividend[7];
                            divisor_neg   <= divisor[7];
                            dividend_abs  <= dividend[7] ? (~dividend + 1) : dividend;
                            divisor_abs   <= divisor[7] ? (~divisor + 1) : divisor;
                            sign_quotient <= dividend[7] ^ divisor[7];
                            sign_remainder<= dividend[7];
                        end else begin
                            dividend_neg  <= 1'b0;
                            divisor_neg   <= 1'b0;
                            dividend_abs  <= dividend;
                            divisor_abs   <= divisor;
                            sign_quotient <= 1'b0;
                            sign_remainder<= 1'b0;
                        end
                        // Initialize SR: remainder is dividend_abs (9 bits, upper 9 bits), quotient 0
                        // The remainder is 9 bits wide; dividend_abs is 8 bits,
                        // so pad LSB with 0, total 9 bits = {dividend_abs, 1'b0}
                        SR <= {dividend_abs, 1'b0, 8'd0};
                        cnt <= 4'd0;
                    end
                end
                CALC: begin
                    // Iterative division step
                    SR <= SR_iter_next;
                    cnt <= cnt + 1'b1;
                end
                DONE: begin
                    // Sign correction of quotient and remainder
                    // Extract unsigned quotient and remainder
                    reg [7:0] quotient_u;
                    reg [7:0] remainder_u;
                    reg [7:0] quotient_s;
                    reg [7:0] remainder_s;

                    quotient_u = SR[7:0];
                    remainder_u= SR[16:9];

                    // Quotient sign correction
                    if (sign && sign_quotient)
                        quotient_s = (~quotient_u + 1);
                    else
                        quotient_s = quotient_u;

                    // Remainder sign correction
                    if (sign && sign_remainder)
                        remainder_s = (~remainder_u + 1);
                    else
                        remainder_s = remainder_u;

                    result <= {remainder_s, quotient_s};
                    res_valid <= 1'b1;
                end
            endcase

            // Clear res_valid when new opn_valid arrives and module is in DONE state
            if (res_valid && opn_valid) begin
                res_valid <= 1'b0;
            end
        end
    end

    // Next state logic combinational
    always @(*) begin
        case(state)
            IDLE: begin
                if (opn_valid)
                    next_state = CALC;
                else
                    next_state = IDLE;
            end
            CALC: begin
                if (cnt == 4'd8)
                    next_state = DONE;
                else
                    next_state = CALC;
            end
            DONE: begin
                if (opn_valid)
                    next_state = CALC;
                else
                    next_state = DONE;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule