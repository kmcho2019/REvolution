module radix2_div (
    input           clk,
    input           rst,
    input           sign,
    input   [7:0]   dividend,
    input   [7:0]   divisor,
    input           opn_valid,
    output reg      res_valid,
    output reg [15:0] result
);

    // State encoding
    localparam IDLE = 2'd0;
    localparam BUSY = 2'd1;
    localparam DONE = 2'd2;

    reg [1:0] state;

    // Registers to latch inputs and signs
    reg [7:0] dividend_reg, divisor_reg;
    reg       dividend_sign, divisor_sign;
    reg [7:0] abs_dividend, abs_divisor;

    // Shift register: 17 bits = {remainder[8:0], quotient[7:0]}
    reg [16:0] SR;

    // Counter for iteration steps (1 to 8)
    reg [3:0] cnt;

    // Helper wires for subtraction
    wire [8:0] remainder;     // current remainder (upper 9 bits)
    wire [8:0] divisor_9;     // divisor zero extended to 9 bits
    wire [9:0] sub_res;       // subtraction result (10 bits)
    wire       sub_ge0;       // subtraction result >= 0

    // Absolute value function for 8-bit signed input
    function [7:0] abs8;
        input [7:0] val;
        begin
            abs8 = val[7] ? (~val + 8'd1) : val;
        end
    endfunction

    // Negate function for 8-bit
    function [7:0] neg8;
        input [7:0] val;
        begin
            neg8 = ~val + 8'd1;
        end
    endfunction

    assign remainder = SR[16:8];           // 9-bit remainder
    assign divisor_9 = {1'b0, abs_divisor}; // 9-bit zero extended divisor
    assign sub_res = {1'b0, remainder} - {1'b0, divisor_9};
    assign sub_ge0 = ~sub_res[9];          // subtraction result >= 0 if MSB is 0

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state        <= IDLE;
            res_valid    <= 1'b0;
            result       <= 16'd0;
            SR           <= 17'd0;
            cnt          <= 4'd0;
            dividend_reg <= 8'd0;
            divisor_reg  <= 8'd0;
            dividend_sign<= 1'b0;
            divisor_sign <= 1'b0;
            abs_dividend <= 8'd0;
            abs_divisor  <= 8'd0;
        end else begin
            case(state)
                IDLE: begin
                    res_valid <= 1'b0;
                    cnt <= 4'd0;
                    if (opn_valid) begin
                        // Latch inputs
                        dividend_reg <= dividend;
                        divisor_reg  <= divisor;

                        if (sign) begin
                            dividend_sign <= dividend[7];
                            divisor_sign  <= divisor[7];
                            abs_dividend  <= abs8(dividend);
                            abs_divisor   <= abs8(divisor);
                        end else begin
                            dividend_sign <= 1'b0;
                            divisor_sign  <= 1'b0;
                            abs_dividend  <= dividend;
                            abs_divisor   <= divisor;
                        end

                        // Initialize SR:
                        // remainder = 0 (9 bits)
                        // quotient = abs_dividend shifted left by 1 bit (to insert quotient bits during division)
                        // According to problem: initialize SR with abs_dividend shifted left by 1 bit in quotient portion,
                        // and remainder zero.

                        // SR = {remainder[8:0], quotient[7:0]}
                        // remainder start = 0
                        // quotient start = abs_dividend shifted left by 1 (multiply by 2)
                        // The quotient portion is bits [7:0], so shift abs_dividend by 1 into quotient:
                        // The LSB of quotient is 0 at start.
                        // So quotient = abs_dividend << 1

                        SR <= {9'd0, abs_dividend << 1};

                        cnt <= 4'd1; // Start count at 1 per problem description

                        // Division by zero immediately goes to DONE state
                        if (abs_divisor == 8'd0) begin
                            state <= DONE;
                        end else begin
                            state <= BUSY;
                        end
                    end
                end
                BUSY: begin
                    if (cnt[3]) begin
                        // MSB of cnt is 1 means cnt >= 8 (since counting 1..8)
                        // Division done
                        state <= DONE;
                        cnt <= 4'd0;

                        // Final SR update after last iteration is not needed here since done in iteration
                    end else begin
                        // Perform one iteration of division:
                        // subtract divisor from remainder if possible
                        if (sub_ge0) begin
                            // remainder = remainder - divisor
                            // shift SR left by 1 bit, insert 1 in quotient LSB
                            SR <= {sub_res[8:0], SR[7:1], 1'b1};
                        end else begin
                            // remainder unchanged
                            // shift SR left by 1 bit, insert 0 in quotient LSB
                            SR <= {remainder, SR[7:1], 1'b0};
                        end

                        cnt <= cnt + 1'b1;
                    end
                end
                DONE: begin
                    if (!res_valid) begin
                        // Handle division by zero
                        reg [7:0] quotient_unsigned;
                        reg [7:0] remainder_unsigned;

                        reg [7:0] quotient_signed;
                        reg [7:0] remainder_signed;

                        quotient_unsigned = SR[7:0];
                        // remainder is bits [16:8], 9 bits with sign bit at MSB (bit 16)
                        // We take bits [16:9] as 8-bit remainder
                        remainder_unsigned = SR[16:9];

                        if (abs_divisor == 8'd0) begin
                            // Saturated quotient = 0xFF
                            quotient_signed  = 8'hFF;
                            // remainder = dividend as is (signed or unsigned)
                            remainder_signed = sign ? dividend_reg : dividend_reg;
                        end else begin
                            if (sign) begin
                                // Correct quotient sign
                                if (dividend_sign ^ divisor_sign)
                                    quotient_signed = neg8(quotient_unsigned);
                                else
                                    quotient_signed = quotient_unsigned;

                                // Correct remainder sign (same as dividend)
                                if (dividend_sign)
                                    remainder_signed = neg8(remainder_unsigned);
                                else
                                    remainder_signed = remainder_unsigned;
                            end else begin
                                quotient_signed  = quotient_unsigned;
                                remainder_signed = remainder_unsigned;
                            end
                        end

                        // Pack result: {remainder[7:0], quotient[7:0]}
                        result <= {remainder_signed, quotient_signed};
                        res_valid <= 1'b1;
                    end else begin
                        // Wait for opn_valid to drop before going to IDLE to avoid immediate restart
                        if (!opn_valid) begin
                            res_valid <= 1'b0;
                            state <= IDLE;
                        end
                    end
                end
                default: state <= IDLE;
            endcase
        end
    end

endmodule