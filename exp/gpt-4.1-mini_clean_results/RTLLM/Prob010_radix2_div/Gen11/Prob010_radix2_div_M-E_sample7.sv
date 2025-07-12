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
    localparam IDLE   = 2'b00;
    localparam DIVIDE = 2'b01;
    localparam DONE   = 2'b10;

    reg [1:0] state, next_state;

    // Registers for absolute values and sign flags
    reg [7:0] dividend_abs, divisor_abs;
    reg       quotient_sign, remainder_sign;

    // 17-bit shift register: [16:8] remainder, [7:0] quotient (shifting left)
    reg [16:0] SR;

    reg [3:0] count;

    // Signals for subtraction trial
    reg [8:0] sub_res; // 9 bits for subtraction result including sign
    wire      sub_nonneg; // 1 if sub_res is >= 0

    // Helper function: absolute value for 8-bit signed numbers
    function [7:0] abs_val;
        input [7:0] val;
        begin
            abs_val = (sign && val[7]) ? (~val + 8'd1) : val;
        end
    endfunction

    // Helper function: two's complement negate 8-bit value
    function [7:0] negate8;
        input [7:0] val;
        begin
            negate8 = ~val + 8'd1;
        end
    endfunction

    // Compute next state
    always @(*) begin
        case (state)
            IDLE:   next_state = (opn_valid && !res_valid) ? DIVIDE : IDLE;
            DIVIDE: next_state = (count == 4'd8) ? DONE : DIVIDE;
            DONE:   next_state = (!res_valid) ? IDLE : DONE; // wait for result to be consumed externally
            default: next_state = IDLE;
        endcase
    end

    // Subtraction trial: remainder (9 bits) - divisor_abs (9 bits)
    // remainder is upper 9 bits of SR (bits [16:8])
    // divisor_abs extended to 9 bits for subtraction
    always @(*) begin
        sub_res = {1'b0, SR[16:8]} - {1'b0, divisor_abs};
    end

    assign sub_nonneg = ~sub_res[8]; // MSB is sign bit, 0 means non-negative

    // Sequential logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state         <= IDLE;
            res_valid     <= 1'b0;
            result        <= 16'd0;
            SR            <= 17'd0;
            count         <= 4'd0;
            dividend_abs  <= 8'd0;
            divisor_abs   <= 8'd0;
            quotient_sign <= 1'b0;
            remainder_sign<= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    res_valid <= 1'b0;
                    if (opn_valid && !res_valid) begin
                        // Calculate absolute values and signs
                        dividend_abs  <= abs_val(dividend);
                        divisor_abs   <= abs_val(divisor);
                        quotient_sign <= sign && (dividend[7] ^ divisor[7]);
                        remainder_sign<= sign && dividend[7];
                        count        <= 4'd0;
                        // Initialize SR: remainder = 0, quotient = dividend_abs
                        // shift dividend_abs left by 8 bits (quotient in lower 8 bits)
                        SR <= {9'd0, dividend_abs};
                    end
                end

                DIVIDE: begin
                    if (divisor_abs == 8'd0) begin
                        // Division by zero: output zero quotient and remainder immediately
                        SR <= 17'd0;
                        count <= 4'd8; // force to done
                    end else if (count < 4'd8) begin
                        // Trial subtraction
                        if (sub_nonneg) begin
                            // Subtraction success: update remainder = sub_res, shift left with quotient bit=1
                            // Shift SR left by 1 bit, set LSB to 1
                            SR <= {sub_res[7:0], SR[7:0], 1'b1};
                        end else begin
                            // Subtraction fail: shift remainder and quotient left with quotient bit=0
                            SR <= {SR[15:0], 1'b0};
                        end
                        count <= count + 1'b1;
                    end
                end

                DONE: begin
                    if (!res_valid) begin
                        // Extraction and sign correction of quotient and remainder
                        reg [7:0] quotient_unsigned;
                        reg [7:0] remainder_unsigned;

                        quotient_unsigned = SR[7:0];
                        remainder_unsigned= SR[16:9]; // remainder is upper 8 bits

                        // Apply sign correction if signed division
                        if (sign) begin
                            if (quotient_sign)
                                quotient_unsigned = negate8(quotient_unsigned);
                            if (remainder_sign)
                                remainder_unsigned = negate8(remainder_unsigned);
                        end

                        result    <= {remainder_unsigned, quotient_unsigned};
                        res_valid <= 1'b1;
                    end
                end
            endcase

            // Clear res_valid once opn_valid is asserted again to start new operation
            if (state == IDLE && opn_valid && res_valid) begin
                res_valid <= 1'b0;
            end
        end
    end

endmodule