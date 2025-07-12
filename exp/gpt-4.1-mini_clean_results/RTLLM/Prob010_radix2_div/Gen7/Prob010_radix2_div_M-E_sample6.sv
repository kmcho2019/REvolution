module radix2_div(
    input           clk,
    input           rst,
    input           sign,           // 1: signed div, 0: unsigned div
    input  [7:0]    dividend,
    input  [7:0]    divisor,
    input           opn_valid,
    output reg      res_valid,
    output reg [15:0] result         // {remainder[7:0], quotient[7:0]}
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        BUSY = 2'b01,
        DONE = 2'b10
    } state_t;
    state_t state, next_state;

    // Internal registers
    reg [16:0] shift_reg; // {remainder[8:0], quotient[7:0]}, 17 bits total
    reg [7:0]  divisor_abs;
    reg        dividend_neg;
    reg        divisor_neg;
    reg        quotient_neg;
    reg        remainder_neg;
    reg [3:0]  count;

    // Absolute value function
    function [7:0] abs_8;
        input [7:0] val;
        begin
            abs_8 = (val[7]) ? (~val + 1) : val;
        end
    endfunction

    // Sign correction function for 8-bit signed
    function [7:0] sign_correct_8;
        input [7:0] val;
        input       neg;
        begin
            sign_correct_8 = neg ? (~val + 1) : val;
        end
    endfunction

    // Next state logic
    always @(*) begin
        case(state)
            IDLE:  next_state = opn_valid ? BUSY : IDLE;
            BUSY:  next_state = (count == 4'd8) ? DONE : BUSY;
            DONE:  next_state = opn_valid ? BUSY : DONE;
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state        <= IDLE;
            res_valid    <= 1'b0;
            result       <= 16'd0;
            shift_reg    <= 17'd0;
            divisor_abs  <= 8'd0;
            dividend_neg <= 1'b0;
            divisor_neg  <= 1'b0;
            quotient_neg <= 1'b0;
            remainder_neg<= 1'b0;
            count        <= 4'd0;
        end else begin
            state <= next_state;
            case(state)
                IDLE: begin
                    res_valid <= 1'b0;
                    count <= 4'd0;

                    if (opn_valid) begin
                        // Compute absolute values and signs
                        if (sign) begin
                            dividend_neg <= dividend[7];
                            divisor_neg  <= divisor[7];
                            divisor_abs  <= abs_8(divisor);
                            quotient_neg <= dividend[7] ^ divisor[7];
                            remainder_neg<= dividend[7];
                            // Initialize shift register with remainder in upper bits and quotient zero
                            // Shift_reg layout: [16:9] remainder(8 bits +1 extension bit=9 bits), [8:1] quotient(8 bits), bit0 unused or zero
                            // We'll store initial remainder as dividend abs shifted left by 1 (to 9 bits) in upper part,
                            // quotient zero initially in lower 8 bits, and bit0 zero.
                            // Here we keep the LSB bit0 as zero (could be a placeholder)
                            shift_reg <= {abs_8(dividend), 8'd0, 1'b0}; // remainder=dividend_abs << 1, quotient=0
                        end else begin
                            dividend_neg <= 1'b0;
                            divisor_neg  <= 1'b0;
                            divisor_abs  <= divisor;
                            quotient_neg <= 1'b0;
                            remainder_neg<= 1'b0;
                            shift_reg <= {dividend, 8'd0, 1'b0};
                        end
                    end
                end
                BUSY: begin
                    // Each cycle:
                    // 1) Shift shift_reg left by 1 bit
                    // 2) Try subtract divisor_abs from upper 9 bits (remainder)
                    // 3) If subtraction non-negative, set LSB of quotient to 1, else revert remainder upper bits and set quotient bit 0

                    // Shift left 1 bit
                    shift_reg <= {shift_reg[15:0], 1'b0};

                    // Attempt subtraction after shift
                    // Compute trial remainder - divisor_abs
                    // Note: remainder is in upper 9 bits (shift_reg[16:8])
                    reg [8:0] trial_remainder;
                    reg [8:0] remainder_val;
                    reg [8:0] remainder_sub;
                    reg borrow;

                    remainder_val = shift_reg[16:8];
                    trial_remainder = remainder_val - divisor_abs;

                    // Check if remainder_val >= divisor_abs by checking MSB of subtraction result (borrow)
                    borrow = (remainder_val < divisor_abs) ? 1'b1 : 1'b0;

                    if (!borrow) begin
                        // Subtraction succeeds, update remainder and set quotient bit to 1
                        // Update remainder bits
                        shift_reg[16:8] <= trial_remainder;
                        // Update quotient LSB to 1
                        shift_reg[0] <= 1'b1;
                    end else begin
                        // Subtraction fails, revert quotient bit 0 to 0
                        // remainder upper bits remain unchanged after shift
                        // quotient bit stays 0 (already zero by shift)
                    end

                    // Increment counter
                    count <= count + 1'b1;
                end
                DONE: begin
                    // Output sign correction
                    reg [7:0] quotient_out;
                    reg [7:0] remainder_out;

                    quotient_out = sign_correct_8(shift_reg[7:0], quotient_neg);
                    remainder_out = sign_correct_8(shift_reg[16:9], remainder_neg);

                    result    <= {remainder_out, quotient_out};
                    res_valid <= 1'b1;

                    if (opn_valid) begin
                        // Prepare for next operation
                        res_valid <= 1'b0;
                        count <= 4'd0;

                        if (sign) begin
                            dividend_neg <= dividend[7];
                            divisor_neg  <= divisor[7];
                            divisor_abs  <= abs_8(divisor);
                            quotient_neg <= dividend[7] ^ divisor[7];
                            remainder_neg<= dividend[7];
                            shift_reg <= {abs_8(dividend), 8'd0, 1'b0};
                        end else begin
                            dividend_neg <= 1'b0;
                            divisor_neg  <= 1'b0;
                            divisor_abs  <= divisor;
                            quotient_neg <= 1'b0;
                            remainder_neg<= 1'b0;
                            shift_reg <= {dividend, 8'd0, 1'b0};
                        end
                    end
                end
                default: ;
            endcase
        end
    end

endmodule