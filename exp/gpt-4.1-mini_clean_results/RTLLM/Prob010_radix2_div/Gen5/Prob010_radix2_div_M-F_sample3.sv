module radix2_div (
    input             clk,
    input             rst,
    input             sign,
    input      [7:0]  dividend,
    input      [7:0]  divisor,
    input             opn_valid,
    output reg        res_valid,
    output reg [15:0] result
);

    // States encoding
    localparam IDLE = 2'd0,
               WORK = 2'd1,
               DONE = 2'd2;

    reg [1:0] state, next_state;

    // Sign flags for operands
    reg dividend_sign, divisor_sign;
    reg quotient_sign, remainder_sign;

    // Absolute values of dividend and divisor
    reg [7:0] dividend_abs;
    reg [7:0] divisor_abs;

    // 17-bit shift register:
    // Bits [16:8] - remainder (9 bits)
    // Bits [7:0]  - quotient (8 bits)
    reg [16:0] shift_reg;

    // Iteration counter
    reg [3:0] count;

    // Combinational subtraction: remainder - divisor
    wire [8:0] remainder = shift_reg[16:8];
    wire [8:0] divisor_ext = {1'b0, divisor_abs};
    wire [8:0] sub_res = remainder - divisor_ext;
    wire sub_res_nonneg = ~sub_res[8]; // If MSB=0 then non-negative

    // Absolute value function
    function [7:0] abs_val;
        input [7:0] val;
        begin
            if (sign && val[7])
                abs_val = (~val) + 8'd1;
            else
                abs_val = val;
        end
    endfunction

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state         <= IDLE;
            res_valid     <= 1'b0;
            result        <= 16'd0;

            dividend_sign <= 1'b0;
            divisor_sign  <= 1'b0;
            quotient_sign <= 1'b0;
            remainder_sign<= 1'b0;

            dividend_abs  <= 8'd0;
            divisor_abs   <= 8'd0;

            shift_reg     <= 17'd0;
            count         <= 4'd0;
        end else begin
            state <= next_state;
            case (state)
                IDLE: begin
                    res_valid <= 1'b0;
                    if (opn_valid) begin
                        dividend_sign <= sign ? dividend[7] : 1'b0;
                        divisor_sign  <= sign ? divisor[7]  : 1'b0;
                        quotient_sign <= sign ? (dividend[7] ^ divisor[7]) : 1'b0;
                        remainder_sign<= sign ? dividend[7] : 1'b0;

                        dividend_abs <= abs_val(dividend);
                        divisor_abs  <= abs_val(divisor);

                        // Initialize remainder with dividend_abs, quotient=0
                        // Shift reg: remainder[16:8] = dividend_abs (8 bits) + 1 bit zero LSB to form 9 bits
                        // remainder lower bit is zero because of left shift by 1 in original description
                        // For clarity, put dividend_abs in upper 8 bits and a zero bit in LSB of remainder:
                        shift_reg <= {dividend_abs, 1'b0, 8'd0}; // 8 bits dividend_abs, 1 zero bit, 8 bits zero quotient
                        count <= 4'd0;
                    end
                end

                WORK: begin
                    if (divisor_abs == 8'd0) begin
                        // Division by zero, do nothing here; quotient and remainder remain zero
                        // count still incremented to finish division
                        count <= count + 4'd1;
                    end else begin
                        if (sub_res_nonneg) begin
                            // subtraction >= 0: update remainder to sub_res, shift left and append 1 to quotient LSB
                            // sub_res[7:0] is new remainder[16:9]
                            // shift left: remainder[16:8] <= sub_res[7:0], remainder LSB lost, quotient shifted left with new LSB=1
                            // Build new shift_reg:
                            // remainder = sub_res[7:0], plus LSB zero appended as least sig bit in 9-bit remainder (note we have 9 bits remainder)
                            // So shift_reg[16:8] <= sub_res[7:0] + next bit
                            // Actually remainder is 9 bits: sub_res is 9 bits already, but sub_res[8] is sign bit, so remainder[16:8] = sub_res[7:0]
                            // After shift left by 1: shift_reg <= {remainder shifted left, quotient shifted left, quotient LSB}
                            // We'll do it by manually shifting:
                            // (remainder << 1) concatenated with quotient and new quotient bit

                            // Prepare next remainder and quotient:
                            // New remainder is sub_res[7:0] (8 bits) + 1 bit zero appended
                            // Wait, since remainder is 9 bits, subtract result is 9 bits,
                            // we keep sub_res[7:0] in remainder[16:9], remainder[8] is LSB of remainder
                            // But problem states remainder upper 8 bits in final result, so keep remainder as 9 bits here.

                            // Let's implement shift left by 1 for combined reg:
                            // shift_reg = {remainder, quotient} << 1 + new quotient bit (1 if subtraction successful)
                            // But since sub_res_nonneg means remainder updated, remainder becomes sub_res[7:0], quotient appended with 1.

                            shift_reg <= {sub_res[7:0], shift_reg[7:0], 1'b1};
                        end else begin
                            // subtraction < 0: remainder unchanged, shift left quotient with 0
                            shift_reg <= {shift_reg[15:0], 1'b0};
                        end
                        count <= count + 4'd1;
                    end
                end

                DONE: begin
                    // Extract raw quotient and remainder
                    reg [7:0] raw_quotient;
                    reg [7:0] raw_remainder;

                    // remainder is bits [16:9], quotient bits [7:0]
                    raw_quotient  = shift_reg[7:0];
                    raw_remainder = shift_reg[16:9];

                    if (sign) begin
                        // Adjust quotient sign
                        if (quotient_sign)
                            raw_quotient = (~raw_quotient + 8'd1);

                        // Adjust remainder sign
                        if (remainder_sign)
                            raw_remainder = (~raw_remainder + 8'd1);
                    end

                    result <= {raw_remainder, raw_quotient};
                    res_valid <= 1'b1;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (opn_valid)
                    next_state = WORK;
            end

            WORK: begin
                if (count == 4'd8)
                    next_state = DONE;
            end

            DONE: begin
                if (!opn_valid)
                    next_state = IDLE;
                else
                    next_state = WORK;
            end
        endcase
    end

endmodule