module radix2_div (
    input          clk,
    input          rst,
    input          sign,
    input  [7:0]   dividend,
    input  [7:0]   divisor,
    input          opn_valid,
    output reg     res_valid,
    output reg [15:0] result
);

    // FSM states
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        RUN  = 2'b01,
        DONE = 2'b10
    } state_t;
    state_t state, next_state;

    // Registered inputs
    reg [7:0] dividend_reg;
    reg [7:0] divisor_reg;
    reg       sign_reg;

    // Absolute values and signs
    reg [7:0] abs_dividend, abs_divisor;
    reg       dividend_sign, divisor_sign;
    reg       quotient_sign;

    // Shift register:
    // SR[16:8]: 9-bit remainder (with extra bit for subtraction)
    // SR[7:0]:  8-bit quotient
    reg [16:0] SR;

    // Negated divisor for subtraction (9 bits)
    reg [8:0] neg_divisor;

    // Counter: counts from 0 to 7 for 8 division cycles
    reg [3:0] cnt;

    // Combinational subtraction result: remainder - divisor = SR[16:8] + neg_divisor
    wire [8:0] sub_res;
    wire       sub_carry;  // carry out of addition (1 if non-negative result)

    assign {sub_carry, sub_res} = SR[16:8] + neg_divisor;

    // FSM state transitions
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // FSM next state logic and control signals
    always @(*) begin
        case(state)
            IDLE: begin
                if (opn_valid && !res_valid)
                    next_state = RUN;
                else
                    next_state = IDLE;
            end
            RUN: begin
                if (cnt == 4'd8)
                    next_state = DONE;
                else
                    next_state = RUN;
            end
            DONE: begin
                if (!opn_valid)
                    next_state = IDLE;
                else
                    next_state = DONE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Main sequential logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            dividend_reg <= 8'b0;
            divisor_reg <= 8'b0;
            sign_reg <= 1'b0;
            abs_dividend <= 8'b0;
            abs_divisor <= 8'b0;
            dividend_sign <= 1'b0;
            divisor_sign <= 1'b0;
            quotient_sign <= 1'b0;
            neg_divisor <= 9'b0;
            SR <= 17'b0;
            cnt <= 4'b0;
            res_valid <= 1'b0;
            result <= 16'b0;
        end else begin
            case(state)
                IDLE: begin
                    res_valid <= 1'b0;
                    cnt <= 4'b0;

                    if (opn_valid && !res_valid) begin
                        // Latch inputs
                        dividend_reg <= dividend;
                        divisor_reg <= divisor;
                        sign_reg <= sign;

                        // Signed/Unsigned absolute values and signs
                        if (sign) begin
                            dividend_sign <= dividend[7];
                            divisor_sign <= divisor[7];
                            abs_dividend <= dividend[7] ? (~dividend + 1'b1) : dividend;
                            abs_divisor <= divisor[7] ? (~divisor + 1'b1) : divisor;
                            quotient_sign <= dividend[7] ^ divisor[7];
                        end else begin
                            dividend_sign <= 1'b0;
                            divisor_sign <= 1'b0;
                            abs_dividend <= dividend;
                            abs_divisor <= divisor;
                            quotient_sign <= 1'b0;
                        end

                        // Initialize shift register SR:
                        // remainder part = abs_dividend shifted left by 1 bit (9 bits)
                        // quotient part = 0
                        // SR[16:8] = abs_dividend << 1 (9 bits)
                        // SR[7:0] = 0
                        SR <= {abs_dividend, 1'b0, 8'b0};

                        // Negated divisor for subtraction, 9 bits
                        // sign extend abs_divisor with leading zero to 9 bits, negate to get -abs_divisor
                        neg_divisor <= (~{1'b0, abs_divisor} + 1'b1);

                        cnt <= 4'd0;
                    end
                end

                RUN: begin
                    // Perform one division iteration per clock

                    // If subtraction non-negative (sub_res[8] == 0)
                    // Update remainder with sub_res[7:0], shift quotient left and set LSB = 1
                    // Else keep remainder, shift quotient left and set LSB = 0

                    if (sub_res[8] == 1'b0) begin
                        // subtraction non-negative: update remainder and quotient bit = 1
                        SR <= {sub_res[7:0], SR[7:0], 1'b1};
                    end else begin
                        // subtraction negative: restore remainder, quotient bit = 0
                        SR <= {SR[15:0], 1'b0};
                    end

                    cnt <= cnt + 1'b1;
                end

                DONE: begin
                    // Division complete; prepare output
                    // Extract quotient and remainder before sign correction
                    // remainder in SR[16:9] (9 bits with extra bit)
                    // The remainder was shifted left by 1 in init, so shift back right by 1
                    // Quotient in SR[7:0]

                    // Apply quotient sign correction combinationally later
                    // For now, do nothing here

                    res_valid <= 1'b1;
                end
            endcase

            // Clear res_valid when leaving DONE and new operation is requested
            if (state == DONE && next_state == IDLE) begin
                res_valid <= 1'b0;
            end
        end
    end

    // Combinational logic for signed quotient correction and result packing
    // Apply quotient sign only when sign_reg is set and quotient_sign is 1
    // quotient_final = quotient or its two's complement if negative
    // remainder_final = remainder shifted right 1 (to undo initial shift)
    wire [7:0] quotient_unsigned = SR[7:0];
    wire [8:0] remainder_shifted = SR[16:9]; // 9 bits remainder with extra bit
    wire [7:0] remainder_corrected = remainder_shifted[8:1]; // drop LSB: shift right by 1

    reg [7:0] quotient_final;

    always @(*) begin
        if (sign_reg && quotient_sign) begin
            quotient_final = (~quotient_unsigned + 1'b1);
        end else begin
            quotient_final = quotient_unsigned;
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            result <= 16'b0;
        end else if (state == DONE) begin
            result <= {remainder_corrected, quotient_final};
        end
    end

endmodule