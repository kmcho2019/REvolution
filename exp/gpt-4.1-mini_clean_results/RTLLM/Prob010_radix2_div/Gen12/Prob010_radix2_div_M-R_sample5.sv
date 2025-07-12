module radix2_div (
    input           clk,
    input           rst,
    input           sign,           // 1: signed, 0: unsigned
    input    [7:0]  dividend,
    input    [7:0]  divisor,
    input           opn_valid,
    output reg      res_valid,
    output reg [15:0] result          // {remainder[7:0], quotient[7:0]}
);

    // State definition
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        DIVIDE = 2'b01,
        DONE = 2'b10
    } state_t;
    state_t state, next_state;

    // Internal signals
    reg [7:0] dividend_r, divisor_r;      // latched inputs
    reg        dividend_neg, divisor_neg; // signs of inputs
    reg [7:0] dividend_mag, divisor_mag;  // absolute values
    reg [3:0] count;                      // count division cycles 0-7

    // Shift register: 17 bits = 9 bits remainder (upper), 8 bits quotient (lower)
    reg [16:0] SR;

    // Extended divisor magnitude (9 bits for subtraction)
    wire [8:0] divisor_ext = {1'b0, divisor_mag};

    // Temporary subtraction result and borrow
    wire [8:0] sub_res = SR[16:8] - divisor_ext;
    wire borrow_sub = sub_res[8];   // borrow if subtraction is negative

    // Sign flags for final correction
    wire quotient_neg = sign & (dividend_neg ^ divisor_neg);
    wire remainder_neg = sign & dividend_neg;

    // Registers to hold final quotient and remainder before sign correction
    reg [7:0] raw_quotient;
    reg [7:0] raw_remainder;
    reg [7:0] quotient_corr;
    reg [7:0] remainder_corr;

    // Next-state logic
    always @(*) begin
        case(state)
            IDLE:
                if (opn_valid && (divisor != 8'd0))
                    next_state = DIVIDE;
                else
                    next_state = IDLE;
            DIVIDE:
                if (count == 4'd7)
                    next_state = DONE;
                else
                    next_state = DIVIDE;
            DONE:
                if (opn_valid)
                    next_state = DIVIDE;
                else
                    next_state = DONE;
            default:
                next_state = IDLE;
        endcase
    end

    // Sequential logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            res_valid <= 1'b0;
            SR <= 17'd0;
            dividend_r <= 8'd0;
            divisor_r <= 8'd0;
            dividend_neg <= 1'b0;
            divisor_neg <= 1'b0;
            dividend_mag <= 8'd0;
            divisor_mag <= 8'd0;
            count <= 4'd0;
            raw_quotient <= 8'd0;
            raw_remainder <= 8'd0;
            quotient_corr <= 8'd0;
            remainder_corr <= 8'd0;
            result <= 16'd0;
        end else begin
            state <= next_state;
            case(state)
                IDLE: begin
                    res_valid <= 1'b0;
                    count <= 4'd0;
                    if (opn_valid && (divisor != 8'd0)) begin
                        // Latch inputs
                        dividend_r <= dividend;
                        divisor_r  <= divisor;
                        if (sign) begin
                            dividend_neg <= dividend[7];
                            divisor_neg  <= divisor[7];
                            dividend_mag <= dividend[7] ? (~dividend + 8'd1) : dividend;
                            divisor_mag  <= divisor[7] ? (~divisor + 8'd1)  : divisor;
                        end else begin
                            dividend_neg <= 1'b0;
                            divisor_neg  <= 1'b0;
                            dividend_mag <= dividend;
                            divisor_mag  <= divisor;
                        end
                        // Initialize SR with remainder=0 and quotient = dividend_mag
                        SR <= {9'd0, dividend_mag};
                    end
                end
                DIVIDE: begin
                    count <= count + 1'b1;
                    if (!borrow_sub) begin
                        // Subtraction success: update remainder and set quotient bit=1
                        // Shift left SR: (remainder, quotient) << 1, set LSB=1
                        SR <= {sub_res, SR[7:1], 1'b1};
                    end else begin
                        // Subtraction fail: restore remainder, set quotient bit=0
                        // Shift left SR: (remainder, quotient) << 1, set LSB=0
                        SR <= {SR[16:8], SR[7:1], 1'b0};
                    end
                end
                DONE: begin
                    if (!res_valid) begin
                        // Capture raw quotient and remainder before sign correction
                        raw_quotient <= SR[7:0];
                        raw_remainder <= SR[16:9];

                        // Apply sign corrections
                        quotient_corr <= quotient_neg ? (~SR[7:0] + 8'd1) : SR[7:0];
                        remainder_corr <= remainder_neg ? (~SR[16:9] + 8'd1) : SR[16:9];

                        // Output result: remainder upper 8 bits, quotient lower 8 bits
                        result <= {remainder_corr, quotient_corr};
                        res_valid <= 1'b1;
                    end

                    if (opn_valid) begin
                        // New operation requested; re-initialize
                        count <= 4'd0;
                        // Latch inputs for new operation
                        dividend_r <= dividend;
                        divisor_r  <= divisor;
                        if (sign) begin
                            dividend_neg <= dividend[7];
                            divisor_neg  <= divisor[7];
                            dividend_mag <= dividend[7] ? (~dividend + 8'd1) : dividend;
                            divisor_mag  <= divisor[7] ? (~divisor + 8'd1)  : divisor;
                        end else begin
                            dividend_neg <= 1'b0;
                            divisor_neg  <= 1'b0;
                            dividend_mag <= dividend;
                            divisor_mag  <= divisor;
                        end
                        // Initialize SR with remainder=0 and quotient = dividend_mag
                        SR <= {9'd0, dividend_mag};
                        res_valid <= 1'b0;
                    end
                end
            endcase
        end
    end

endmodule