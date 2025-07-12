module radix2_div (
    input           clk,
    input           rst,
    input           sign,
    input   [7:0]   dividend,
    input   [7:0]   divisor,
    input           opn_valid,
    input           res_ready,
    output reg      res_valid,
    output reg [15:0] result
);

// State encoding
localparam IDLE = 2'd0;
localparam BUSY = 2'd1;
localparam DONE = 2'd2;

reg [1:0] state;

// Registers for internal signals
reg [7:0] dividend_reg, divisor_reg;
reg       dividend_sign, divisor_sign;
reg [7:0] abs_dividend, abs_divisor;

reg [16:0] SR;        // Shift Register: {Remainder[8:0], Quotient[7:0]} + 1 bit extra for shift
reg [3:0]  cnt;        // Counts 0..8 division steps (need 8 steps for 8-bit divisor)

wire [8:0] rem;        // Current remainder (9 bits, sign extended 1 bit)
wire [8:0] divisor_9;  // 9-bit divisor (zero-extended)
wire [9:0] sub;        // subtraction result with extra bit for sign detection
wire        sub_ge0;   // subtraction result >= 0 ?

// Functions for absolute value and negation of 8-bit signed numbers
function [7:0] abs8;
    input [7:0] val;
    begin
        abs8 = val[7] ? (~val + 8'd1) : val;
    end
endfunction

function [7:0] neg8;
    input [7:0] val;
    begin
        neg8 = ~val + 8'd1;
    end
endfunction

// Extract remainder from SR: upper 9 bits (SR[16:8])
assign rem = SR[16:8];
// divisor_9 zero-extended to 9 bits
assign divisor_9 = {1'b0, abs_divisor};
// Subtract divisor from remainder
assign sub = {1'b0, rem} - {1'b0, divisor_9};
// Check if subtraction is non-negative
assign sub_ge0 = ~sub[9];

// Sequential logic
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
        case (state)
            IDLE: begin
                res_valid <= 1'b0;
                cnt       <= 4'd0;
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

                    // Initialize shift register:
                    // remainder = 0 (9 bits)
                    // quotient = abs_dividend shifted left by 1 bit (with LSB 0)
                    // SR = {remainder[8:0], quotient[7:0], 1'b0} but quotient fits 8 bits, so we store quotient in SR[7:0]
                    // Actually, SR 17 bits = remainder (9 bits) + quotient (8 bits)
                    // Initial remainder zero, quotient loaded as dividend_abs
                    SR <= {9'd0, abs_dividend};
                    cnt <= 4'd0;

                    // Move to BUSY only if divisor != 0, else immediate done
                    if (abs_divisor == 8'd0) begin
                        state <= DONE;
                    end else begin
                        state <= BUSY;
                    end
                end
            end

            BUSY: begin
                if (cnt < 8) begin
                    // At each cycle:
                    // shift remainder and quotient left by 1 bit
                    // subtract divisor if possible
                    if (sub_ge0) begin
                        // subtraction >= 0, update remainder to sub result (9 bits)
                        // Shift left remainder and quotient by 1, insert 1 in quotient LSB
                        // New remainder = sub[8:0]
                        // New quotient = shift left quotient + 1
                        SR <= {sub[8:0], SR[7:1], 1'b1};
                    end else begin
                        // subtraction < 0, keep remainder unchanged
                        // Shift left remainder and quotient by 1, insert 0 in quotient LSB
                        SR <= {rem, SR[7:1], 1'b0};
                    end
                    cnt <= cnt + 1'b1;
                end else begin
                    // Finished 8 iterations -> done
                    state <= DONE;
                end
            end

            DONE: begin
                if (!res_valid) begin
                    // Output result with sign correction and division by zero handling

                    // Prepare quotient and remainder from SR
                    // remainder: upper 9 bits SR[16:8], but only 8 bits remainder, MSB is sign extended
                    // Quotient: lower 8 bits SR[7:0]

                    reg [7:0] quotient_unsigned;
                    reg [7:0] remainder_unsigned;
                    reg [7:0] quotient_signed, remainder_signed;

                    quotient_unsigned = SR[7:0];
                    remainder_unsigned= SR[16:9]; // remainder is 8 bits, SR[16:8] is 9 bits but top bit is sign extension

                    // Handle division by zero:
                    if (abs_divisor == 8'd0) begin
                        // Saturated quotient - all 1's, remainder = dividend (signed or unsigned)
                        quotient_signed  = 8'hFF;
                        remainder_signed = sign ? dividend_reg : dividend_reg; // remainder is dividend as is
                    end else begin
                        // Signed correction if sign == 1
                        if (sign) begin
                            // Quotient sign = dividend_sign ^ divisor_sign
                            if (dividend_sign ^ divisor_sign)
                                quotient_signed = neg8(quotient_unsigned);
                            else
                                quotient_signed = quotient_unsigned;

                            // Remainder sign = dividend_sign
                            if (dividend_sign)
                                remainder_signed = neg8(remainder_unsigned);
                            else
                                remainder_signed = remainder_unsigned;
                        end else begin
                            quotient_signed  = quotient_unsigned;
                            remainder_signed = remainder_unsigned;
                        end
                    end

                    // Pack result: upper 8 bits = remainder, lower 8 bits = quotient
                    result <= {remainder_signed, quotient_signed};
                    res_valid <= 1'b1;
                end else begin
                    // Wait for res_ready to accept result and new opn_valid low to go to IDLE
                    if (res_ready && !opn_valid) begin
                        res_valid <= 1'b0;
                        state <= IDLE;
                    end
                end
            end

            default: begin
                state <= IDLE;
            end
        endcase
    end
end

endmodule