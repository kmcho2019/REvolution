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

    // Internal registers
    reg dividend_sign, divisor_sign;
    reg quotient_sign, remainder_sign;

    reg [7:0] dividend_abs;
    reg [7:0] divisor_abs;

    // 17-bit shift reg: upper 9 bits remainder, lower 8 bits quotient
    reg [16:0] shift_reg;

    // Counter for iterations (0 to 7)
    reg [3:0] count;

    // Combinational subtraction: remainder - divisor
    wire [8:0] remainder = shift_reg[16:8];
    wire [8:0] divisor_ext = {1'b0, divisor_abs};
    wire [8:0] sub_res = remainder - divisor_ext;
    wire sub_res_nonneg = ~sub_res[8]; // MSB = sign bit

    // Calculate absolute value helper function (used in sequential block)
    function [7:0] abs_val;
        input [7:0] val;
        begin
            if (sign && val[7])
                abs_val = (~val) + 8'd1;
            else
                abs_val = val;
        end
    endfunction

    // Sequential block controlling state, registers and division steps
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state        <= IDLE;
            res_valid    <= 1'b0;
            result       <= 16'd0;

            dividend_sign<= 1'b0;
            divisor_sign <= 1'b0;
            quotient_sign<= 1'b0;
            remainder_sign<= 1'b0;

            dividend_abs <= 8'd0;
            divisor_abs  <= 8'd0;

            shift_reg    <= 17'd0;
            count        <= 4'd0;
        end else begin
            state <= next_state;
            case (state)
                IDLE: begin
                    res_valid <= 1'b0;
                    if (opn_valid) begin
                        // Capture signs
                        dividend_sign <= sign ? dividend[7] : 1'b0;
                        divisor_sign  <= sign ? divisor[7]  : 1'b0;
                        quotient_sign <= sign ? (dividend[7] ^ divisor[7]) : 1'b0;
                        remainder_sign<= sign ? dividend[7] : 1'b0;

                        // Absolute values
                        dividend_abs <= abs_val(dividend);
                        divisor_abs  <= abs_val(divisor);

                        // Initialize shift register: remainder left shifted by 1 concatenated with quotient bits = 0
                        // So shift_reg = {remainder(9 bits), quotient(8 bits)} = dividend_abs shifted left by 1
                        // The remainder is 9 bits for subtraction purposes (one extra bit)
                        shift_reg <= {dividend_abs, 8'd0};

                        count <= 4'd0;
                    end
                end

                WORK: begin
                    // If divisor is zero, division is invalid, keep quotient and remainder 0 (already zero)
                    if (divisor_abs == 8'd0) begin
                        // Nothing to do; will go to DONE
                    end else begin
                        // Try subtraction: remainder - divisor
                        if (sub_res_nonneg) begin
                            // If subtraction result >=0, update remainder with sub_res and shift left inserting 1 in quotient LSB
                            shift_reg[16:8] <= sub_res[8:0];
                            shift_reg <= {sub_res[7:0], shift_reg[7:0], 1'b1};
                        end else begin
                            // If subtraction <0, no update to remainder, shift left inserting 0 in quotient LSB
                            shift_reg <= {shift_reg[15:0], 1'b0};
                        end
                    end

                    count <= count + 4'd1;
                end

                DONE: begin
                    // Apply sign corrections

                    // Extract quotient and remainder (quotient is lower 8 bits, remainder upper 8 bits of 9-bit remainder)
                    reg [7:0] raw_quotient;
                    reg [7:0] raw_remainder;

                    raw_quotient = shift_reg[7:0];
                    raw_remainder= shift_reg[16:9];  // remainder is upper 8 bits of the 9-bit remainder (discard LSB bit of remainder field)

                    // Because remainder was 9-bit but output remainder is 8-bit, we drop the LSB of remainder part (shift_reg[8])
                    // This matches the problem statement of 8-bit remainder in upper bits.

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
                    next_state = WORK; // support starting new op right away
            end
        endcase
    end

endmodule