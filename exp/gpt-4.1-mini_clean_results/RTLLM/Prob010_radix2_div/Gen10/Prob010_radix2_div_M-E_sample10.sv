module radix2_div (
    input              clk,
    input              rst,
    input              sign,         // 1: signed division, 0: unsigned
    input       [7:0]  dividend,
    input       [7:0]  divisor,
    input              opn_valid,
    output reg         res_valid,
    output reg [15:0]  result         // {remainder[7:0], quotient[7:0]}
);

    // FSM states
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        DIVIDE = 2'b01,
        DONE = 2'b10
    } state_t;

    state_t state, next_state;

    // Latch inputs
    reg [7:0] dividend_reg, divisor_reg;
    reg       dividend_neg, divisor_neg;
    reg [7:0] dividend_abs, divisor_abs;

    // 17-bit shift register: {remainder[8:0], quotient[7:0]}
    reg [16:0] SR;

    // Counter for division iterations (0 to 7)
    reg [3:0] count;

    // Temporary wires for subtraction
    reg [8:0] remainder_sub;
    reg       sub_no_borrow; // indicates if remainder >= divisor_abs

    // Registers for corrected final quotient and remainder
    reg [7:0] quotient_final;
    reg [7:0] remainder_final;

    // Sign flags for result adjustment
    wire quotient_neg = sign & (dividend_neg ^ divisor_neg);
    wire remainder_neg = sign & dividend_neg;

    // FSM sequential logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            res_valid <= 1'b0;
            result <= 16'd0;
            SR <= 17'd0;
            dividend_reg <= 8'd0;
            divisor_reg <= 8'd0;
            dividend_neg <= 1'b0;
            divisor_neg <= 1'b0;
            dividend_abs <= 8'd0;
            divisor_abs <= 8'd0;
            count <= 4'd0;
            quotient_final <= 8'd0;
            remainder_final <= 8'd0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    res_valid <= 1'b0;
                    if (opn_valid && (divisor != 8'd0)) begin
                        dividend_reg <= dividend;
                        divisor_reg <= divisor;

                        if (sign) begin
                            dividend_neg <= dividend[7];
                            divisor_neg <= divisor[7];
                            dividend_abs <= dividend[7] ? (~dividend + 8'd1) : dividend;
                            divisor_abs <= divisor[7] ? (~divisor + 8'd1) : divisor;
                        end else begin
                            dividend_neg <= 1'b0;
                            divisor_neg <= 1'b0;
                            dividend_abs <= dividend;
                            divisor_abs <= divisor;
                        end

                        // Initialize SR: remainder=0 (9 bits), quotient=dividend_abs (8 bits)
                        // Starting point before division cycles
                        SR <= {9'd0, dividend_abs};

                        count <= 4'd0;
                    end
                end

                DIVIDE: begin
                    // Perform one division iteration per clock
                    // Step 1: shift SR left by 1 bit
                    // SR_next = {SR[15:0], 1'b0}
                    // Step 2: subtract divisor_abs from remainder portion (upper 9 bits)
                    // remainder_sub = SR[16:8] - divisor_abs
                    // If remainder_sub >= 0 (no borrow), accept subtraction and set quotient LSB to 1
                    // Else restore remainder and set quotient LSB to 0

                    // Calculate shifted SR
                    reg [16:0] SR_shifted;
                    SR_shifted = {SR[15:0], 1'b0};

                    // Subtract divisor_abs from remainder portion
                    remainder_sub = SR_shifted[16:8] - {1'b0, divisor_abs};

                    if (!remainder_sub[8]) begin // MSB=0 means no borrow
                        // Update SR: remainder = remainder_sub, quotient LSB = 1
                        SR <= {remainder_sub[8:0], SR_shifted[7:1], 1'b1};
                    end else begin
                        // Borrow occurred, restore remainder, quotient LSB = 0
                        SR <= {SR_shifted[16:8], SR_shifted[7:1], 1'b0};
                    end

                    count <= count + 1'b1;
                end

                DONE: begin
                    res_valid <= 1'b1;
                    // Wait for opn_valid low to clear res_valid and return to IDLE
                    if (!opn_valid) begin
                        res_valid <= 1'b0;
                    end
                end
            endcase
        end
    end

    // FSM combinational logic for next state
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (opn_valid && (divisor != 8'd0)) next_state = DIVIDE;
            end

            DIVIDE: begin
                if (count == 4'd8) next_state = DONE;
            end

            DONE: begin
                if (!opn_valid) next_state = IDLE;
            end
        endcase
    end

    // Output logic and signed correction after division completes
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            quotient_final <= 8'd0;
            remainder_final <= 8'd0;
            result <= 16'd0;
        end else if (state == DONE && next_state == DONE) begin
            // Extract raw quotient and remainder from SR
            // remainder in upper 9 bits, quotient in lower 8 bits
            // remainder is 9 bits, we take lower 8 bits (discard MSB as it may be zero or sign)
            reg [8:0] rem_raw;
            reg [7:0] quo_raw;
            rem_raw = SR[16:8];
            quo_raw = SR[7:0];

            // Correct signs if signed mode enabled
            quotient_final <= quotient_neg ? (~quo_raw + 8'd1) : quo_raw;
            remainder_final <= remainder_neg ? (~rem_raw[7:0] + 8'd1) : rem_raw[7:0];

            // Pack result: remainder[7:0] upper, quotient[7:0] lower
            result <= {remainder_final, quotient_final};
        end
    end

endmodule