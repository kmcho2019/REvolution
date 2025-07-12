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

    // SR: {remainder[8:0], quotient[7:0]}, 17 bits
    reg [16:0] SR;

    reg [3:0] cnt;  // count 0..8 for 8 iterations

    // Wires for subtraction logic
    wire [8:0] remainder_part = SR[16:8];          // upper 9 bits = remainder part
    wire [9:0] sub_res = {1'b0, remainder_part} - {1'b0, divisor_abs};
    wire       borrow = sub_res[9];                 // borrow means remainder < divisor_abs

    wire [8:0] remainder_next = borrow ? remainder_part : sub_res[8:0];
    wire       quotient_bit = borrow ? 1'b0 : 1'b1;

    // Shift SR left by 1 bit, insert quotient_bit into LSB of quotient part (SR[0])
    wire [16:0] SR_shifted = {SR[15:0], 1'b0};

    // Absolute value calculation combinational helpers
    wire [7:0] dividend_abs = (sign && dividend[7]) ? (~dividend + 1'b1) : dividend;
    wire [7:0] divisor_abs_wire = (sign && divisor[7]) ? (~divisor + 1'b1) : divisor;

    // Sign of quotient and remainder
    wire sign_quotient_wire = (sign) ? (dividend[7] ^ divisor[7]) : 1'b0;
    wire sign_remainder_wire = (sign) ? dividend[7] : 1'b0;

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
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin
                    res_valid <= 1'b0;
                    cnt <= 4'd0;

                    if (opn_valid) begin
                        dividend_reg <= dividend;
                        divisor_reg <= divisor;
                        dividend_neg <= dividend[7];
                        divisor_neg <= divisor[7];
                        sign_quotient <= sign_quotient_wire;
                        sign_remainder <= sign_remainder_wire;
                        divisor_abs <= divisor_abs_wire;

                        // Initialize SR: remainder = dividend_abs shifted left by 1 (9 bits), quotient=0
                        // We align dividend_abs in bits [15:8], then left shift by 1 bit into remainder portion SR[16:8]
                        // Since dividend_abs is 8 bits, remainder is 9 bits: remainder = {dividend_abs,1'b0}
                        SR <= {dividend_abs, 1'b0, 8'b0}; // remainder 9 bits, quotient 8 bits zeroed
                    end
                end

                DIVIDE: begin
                    cnt <= cnt + 1'b1;

                    // Compute next SR:
                    // New remainder = remainder_next (9 bits)
                    // New quotient = shift left by 1 + quotient_bit inserted at LSB
                    // So SR = {remainder_next, shifted_quotient[7:1], quotient_bit}

                    SR <= {remainder_next, SR_shifted[7:1], quotient_bit};
                end

                DONE: begin
                    res_valid <= 1'b1;
                    // Keep result stable until next operation

                    if (opn_valid) begin
                        res_valid <= 1'b0;
                    end
                end
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
                    next_state = DIVIDE;
            end
        endcase
    end

    // Result sign correction after division completes
    // This is done combinationally and latched in sequential block on cnt==8

    reg [7:0] quotient_unsigned;
    reg [8:0] remainder_unsigned_9b;
    reg [7:0] remainder_unsigned; // Take lower 8 bits of remainder (discard LSB)

    reg [7:0] quotient_signed;
    reg [7:0] remainder_signed;

    always @(posedge clk) begin
        if (state == DIVIDE && cnt == 4'd8) begin
            quotient_unsigned = SR[7:0];
            remainder_unsigned_9b = SR[16:8]; // 9 bits remainder

            // Because remainder is 9 bits and result output remainder is only 8 bits,
            // drop the LSB (lowest) remainder bit by shifting right 1 to get the integer remainder.
            // This is consistent with dividend shifted left by 1 at start.
            remainder_unsigned = remainder_unsigned_9b[8:1];

            // Sign correction for quotient
            if (sign && sign_quotient) begin
                quotient_signed = (~quotient_unsigned) + 1'b1;
            end else begin
                quotient_signed = quotient_unsigned;
            end

            // Sign correction for remainder
            if (sign && sign_remainder) begin
                remainder_signed = (~remainder_unsigned) + 1'b1;
            end else begin
                remainder_signed = remainder_unsigned;
            end

            result <= {remainder_signed, quotient_signed};
        end
    end

endmodule