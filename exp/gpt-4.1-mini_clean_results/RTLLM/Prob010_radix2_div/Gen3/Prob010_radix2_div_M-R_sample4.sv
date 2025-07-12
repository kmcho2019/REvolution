module radix2_div(
    input              clk,
    input              rst,
    input              sign,         // 1 for signed division, 0 for unsigned
    input      [7:0]   dividend,
    input      [7:0]   divisor,
    input              opn_valid,
    output reg         res_valid,
    output reg [15:0]  result         // {remainder[7:0], quotient[7:0]}
);

    // FSM states
    typedef enum logic [1:0] {
        IDLE   = 2'b00,
        DIVIDE = 2'b01,
        DONE   = 2'b10
    } state_t;
    state_t state, next_state;

    // Internal registers
    reg [7:0] dividend_reg;
    reg [7:0] divisor_reg;

    reg        dividend_neg;
    reg        divisor_neg;
    reg        sign_quotient;
    reg        sign_remainder;

    reg [7:0] divisor_abs;
    reg [15:0] dividend_abs_ext; // dividend_abs shifted left by 8

    reg [16:0] SR; // {remainder[8:0], quotient[7:0]} in shift reg

    reg [3:0] cnt;  // counter 0..8

    // Wires for subtraction
    wire [8:0] remainder_part = SR[16:8];  // upper 9 bits remainder
    wire [9:0] sub_res = {1'b0, remainder_part} - {1'b0, divisor_abs};
    wire       borrow = sub_res[9];

    // Combinational signals for next SR
    wire [8:0] remainder_next = borrow ? remainder_part : sub_res[8:0];
    wire       quotient_bit = borrow ? 1'b0 : 1'b1;
    wire [16:0] SR_shifted = {SR[15:0], 1'b0}; // SR shifted left by 1

    // FSM sequential logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            res_valid <= 1'b0;
            result <= 16'b0;
            SR <= 17'b0;
            cnt <= 4'b0;
            dividend_reg <= 8'b0;
            divisor_reg <= 8'b0;
            dividend_neg <= 1'b0;
            divisor_neg <= 1'b0;
            sign_quotient <= 1'b0;
            sign_remainder <= 1'b0;
            divisor_abs <= 8'b0;
            dividend_abs_ext <= 16'b0;
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin
                    res_valid <= 1'b0;
                    cnt <= 4'd0;

                    if (opn_valid) begin
                        dividend_reg <= dividend;
                        divisor_reg <= divisor;

                        if (sign) begin
                            dividend_neg <= dividend[7];
                            divisor_neg <= divisor[7];

                            // Absolute values
                            dividend_abs_ext <= ((dividend[7]) ? ((~dividend + 1) & 8'hFF) : dividend) << 8;
                            divisor_abs <= (divisor[7]) ? (~divisor + 1) : divisor;

                            sign_quotient <= dividend[7] ^ divisor[7];
                            sign_remainder <= dividend[7];
                        end else begin
                            dividend_neg <= 1'b0;
                            divisor_neg <= 1'b0;
                            sign_quotient <= 1'b0;
                            sign_remainder <= 1'b0;

                            dividend_abs_ext <= dividend << 8;
                            divisor_abs <= divisor;
                        end

                        // Initialize SR = {remainder=dividend_abs_ext[15:7], quotient=0}
                        SR <= {dividend_abs_ext[15:7], 8'b0};
                    end
                end

                DIVIDE: begin
                    cnt <= cnt + 1'b1;

                    // Update SR with new remainder and quotient bit after subtraction decision
                    // SR_next = {remainder_next, SR_shifted[7:1], quotient_bit}
                    SR <= {remainder_next, SR_shifted[7:1], quotient_bit};
                end

                DONE: begin
                    res_valid <= 1'b1;
                    // Result has been assigned in combinational logic below
                    // Wait until next opn_valid to clear res_valid
                    if (opn_valid) begin
                        res_valid <= 1'b0;
                    end
                end

                default: ;
            endcase
        end
    end

    // FSM combinational next state logic
    always @(*) begin
        next_state = state;
        case(state)
            IDLE: begin
                if (opn_valid)
                    next_state = DIVIDE;
            end
            DIVIDE: begin
                if (cnt == 4'd8)
                    next_state = DONE;
            end
            DONE: begin
                if (opn_valid)
                    next_state = DIVIDE; // start new division
                else
                    next_state = DONE;
            end
        endcase
    end

    // Result calculation - sign correction done combinationally at DONE state
    always @(posedge clk) begin
        if (state == DIVIDE && cnt == 4'd8) begin
            // Extract quotient and remainder before sign correction
            reg [7:0] quotient_unsigned;
            reg [7:0] remainder_unsigned;
            reg [7:0] quotient_signed;
            reg [7:0] remainder_signed;

            quotient_unsigned = SR[7:0];
            remainder_unsigned = SR[16:9]; // upper 8 bits remainder

            // Sign correction
            if (sign && sign_quotient) begin
                quotient_signed = (~quotient_unsigned) + 1'b1;
            end else begin
                quotient_signed = quotient_unsigned;
            end

            if (sign && sign_remainder) begin
                remainder_signed = (~remainder_unsigned) + 1'b1;
            end else begin
                remainder_signed = remainder_unsigned;
            end

            result <= {remainder_signed, quotient_signed};
        end
    end

endmodule