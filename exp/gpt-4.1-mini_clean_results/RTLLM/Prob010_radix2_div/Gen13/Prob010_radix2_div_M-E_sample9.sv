module radix2_div (
    input             clk,
    input             rst,
    input             sign,            // 1: signed division, 0: unsigned division
    input      [7:0]  dividend,
    input      [7:0]  divisor,
    input             opn_valid,
    output reg        res_valid,
    output reg [15:0] result           // [15:8]: remainder, [7:0]: quotient
);

    // FSM states
    localparam [1:0]
        IDLE = 2'b00,
        BUSY = 2'b01,
        DONE = 2'b10;

    reg [1:0] state, next_state;

    // Registers to hold signed flags and abs values
    reg dividend_sign, divisor_sign;
    reg [7:0] dividend_abs, divisor_abs;
    reg quotient_sign, remainder_sign;

    // 16-bit shift register holding remainder and quotient
    // upper 8 bits remainder, lower 8 bits quotient
    reg [15:0] SR;

    // 4-bit cycle counter (0 to 7)
    reg [3:0] count;

    // Internal variables for subtraction and decision
    reg [8:0] remainder_ext;      // 9-bit extended remainder for subtraction
    reg [8:0] remainder_sub;      // subtraction result

    // FSM sequential
    always @(posedge clk) begin
        if (rst) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // FSM combinational
    always @(*) begin
        case(state)
            IDLE:  next_state = (opn_valid && !res_valid) ? BUSY : IDLE;
            BUSY:  next_state = (count == 4'd8) ? DONE : BUSY;
            DONE:  next_state = (res_valid && opn_valid) ? BUSY : (res_valid ? DONE : IDLE);
            default: next_state = IDLE;
        endcase
    end

    // Capture inputs, initialize at IDLE start of operation
    always @(posedge clk) begin
        if (rst) begin
            res_valid       <= 1'b0;
            result          <= 16'd0;
            dividend_sign   <= 1'b0;
            divisor_sign    <= 1'b0;
            dividend_abs    <= 8'd0;
            divisor_abs     <= 8'd0;
            quotient_sign   <= 1'b0;
            remainder_sign  <= 1'b0;
            SR              <= 16'd0;
            count           <= 4'd0;
        end else begin
            case(state)
                IDLE: begin
                    res_valid <= 1'b0;
                    count <= 4'd0;
                    if(opn_valid && !res_valid) begin
                        // Determine signs and absolute values based on 'sign' input
                        if(sign) begin
                            dividend_sign <= dividend[7];
                            divisor_sign  <= divisor[7];

                            dividend_abs <= (dividend[7]) ? (~dividend + 8'd1) : dividend;
                            divisor_abs  <= (divisor[7]) ? (~divisor + 8'd1) : divisor;
                        end else begin
                            dividend_sign <= 1'b0;
                            divisor_sign  <= 1'b0;
                            dividend_abs  <= dividend;
                            divisor_abs   <= divisor;
                        end
                        quotient_sign  <= (sign && (dividend[7] ^ divisor[7]));
                        remainder_sign <= (sign && dividend[7]);

                        // Initialize shift register: remainder=0, quotient=dividend_abs
                        SR <= {8'd0, dividend_abs};
                    end
                end

                BUSY: begin
                    // Each cycle, shift left SR by 1
                    // Extract remainder and perform subtraction with divisor_abs
                    // If subtraction >=0, update remainder and set quotient bit=1, else restore remainder and quotient bit=0
                    remainder_ext = {1'b0, SR[15:8]};  // extend remainder to 9 bits unsigned
                    remainder_sub = remainder_ext - {1'b0, divisor_abs};

                    // Shift SR left by 1
                    // Shift left full 16-bit SR by 1, discarding MSB of remainder
                    // Quotient bits shifted left by 1 (in SR[7:0]) plus new quotient bit at LSB

                    // Determine new LSB quotient bit depending on subtraction sign
                    if (remainder_sub[8] == 1'b0) begin
                        // remainder_sub >= 0, so subtraction successful
                        // update remainder with remainder_sub (lower 8 bits)
                        // set quotient bit to 1
                        SR <= {remainder_sub[7:0], SR[7:0], 1'b1} << 1;
                        // Correction: The above line is incorrect because it concatenates 17 bits
                        // Proper way:
                        // Shift SR left by 1
                        // Then set remainder bits to remainder_sub[7:0]
                        // Set quotient LSB to 1

                        // To do this atomically, we do:
                        SR <= {remainder_sub[7:0], SR[7:0]} << 1;
                        SR[0] <= 1'b1; // LSB quotient bit set to 1
                    end else begin
                        // remainder_sub < 0, subtraction failed
                        // keep remainder as shifted (from SR shifted left by 1)
                        // set quotient bit to 0
                        SR <= SR << 1;
                        SR[0] <= 1'b0; // LSB quotient bit set to 0
                    end
                    count <= count + 1;
                end

                DONE: begin
                    res_valid <= 1'b1;
                    // Apply sign correction to quotient and remainder on result

                    // Extract current quotient and remainder raw from SR
                    // quotient: SR[7:0]
                    // remainder: SR[15:8]
                    // Signs handled below

                    // Once done, remain in DONE until result consumed or new opn_valid comes
                end
            endcase
        end
    end

    // Because of the limitation in the always block (cannot modify part-select and bit-select of reg directly),
    // we need to rewrite the BUSY state shift and update with intermediate variables.

    reg [15:0] SR_next;
    always @(*) begin
        if (state == BUSY) begin
            remainder_ext = {1'b0, SR[15:8]};
            remainder_sub = remainder_ext - {1'b0, divisor_abs};

            if (remainder_sub[8] == 1'b0) begin
                // subtraction success
                SR_next = {remainder_sub[7:0], SR[7:0]} << 1;
                SR_next[0] = 1'b1;
            end else begin
                // subtraction fail
                SR_next = SR << 1;
                SR_next[0] = 1'b0;
            end
        end else begin
            SR_next = SR;
        end
    end

    // Synchronize SR update on clock, separately from main always block for clarity
    always @(posedge clk) begin
        if (!rst && state == BUSY) begin
            SR <= SR_next;
        end
    end

    // Final sign correction logic applied only when in DONE state, assign result output

    reg [7:0] quotient_raw;
    reg [7:0] remainder_raw;
    reg [7:0] quotient_corr;
    reg [7:0] remainder_corr;

    always @(*) begin
        quotient_raw = SR[7:0];
        remainder_raw = SR[15:8];

        // Quotient sign correction: negate if quotient_sign
        if (quotient_sign)
            quotient_corr = (~quotient_raw) + 8'd1;
        else
            quotient_corr = quotient_raw;

        // Remainder sign correction: negate if remainder_sign
        if (remainder_sign)
            remainder_corr = (~remainder_raw) + 8'd1;
        else
            remainder_corr = remainder_raw;
    end

    always @(posedge clk) begin
        if (state == DONE) begin
            result <= {remainder_corr, quotient_corr};
        end
    end

endmodule