module radix2_div(
    input              clk,
    input              rst,
    input              sign,          // 1 for signed division, 0 for unsigned
    input      [7:0]   dividend,
    input      [7:0]   divisor,
    input              opn_valid,
    output reg         res_valid,
    output reg [15:0]  result          // {remainder[7:0], quotient[7:0]}
);

    // State encoding
    localparam IDLE   = 1'b0;
    localparam DIVIDE = 1'b1;

    reg state;
    reg [3:0] cnt;          // iteration counter 0-8
    reg [16:0] SR;          // Shift register: upper 9 bits remainder, lower 8 bits quotient
    reg [7:0] divisor_abs;
    reg [15:0] dividend_abs_ext; // dividend_abs shifted left by 8 bits
    reg sign_quotient;
    reg sign_remainder;

    reg dividend_neg;
    reg divisor_neg;

    // Absolute values for dividend and divisor
    wire [7:0] dividend_abs = (sign && dividend[7]) ? (~dividend + 1'b1) : dividend;
    wire [7:0] divisor_abs_wire = (sign && divisor[7]) ? (~divisor + 1'b1) : divisor;

    // Wires for shifted SR and subtraction
    wire [16:0] SR_shifted = {SR[15:0], 1'b0};
    wire [8:0] remainder_part_shifted = SR_shifted[16:8]; // upper 9 bits

    // Subtract divisor_abs from remainder_part_shifted (9 bits)
    wire [9:0] sub_res;
    wire sub_borrow;
    assign sub_res = {1'b0, remainder_part_shifted} - {1'b0, divisor_abs};
    assign sub_borrow = sub_res[9];

    // Next remainder and quotient bit determined combinationally
    wire [8:0] remainder_next = sub_borrow ? remainder_part_shifted : sub_res[8:0];
    wire quotient_bit = sub_borrow ? 1'b0 : 1'b1;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset all regs
            state <= IDLE;
            cnt <= 4'd0;
            SR <= 17'd0;
            divisor_abs <= 8'd0;
            dividend_abs_ext <= 16'd0;
            res_valid <= 1'b0;
            result <= 16'd0;
            dividend_neg <= 1'b0;
            divisor_neg <= 1'b0;
            sign_quotient <= 1'b0;
            sign_remainder <= 1'b0;
        end else begin
            case(state)
                IDLE: begin
                    res_valid <= 1'b0;
                    if (opn_valid) begin
                        // Latch sign info
                        dividend_neg <= sign && dividend[7];
                        divisor_neg  <= sign && divisor[7];
                        sign_quotient <= (dividend[7] ^ divisor[7]) & sign; // only if signed
                        sign_remainder <= dividend[7] & sign;

                        // Save absolute values
                        divisor_abs <= divisor_abs_wire;
                        dividend_abs_ext <= {8'd0, dividend_abs} << 8; // shift dividend_abs left 8 bits

                        // Initialize SR: upper 9 bits = dividend_abs_ext[15:7], lower 8 bits=0
                        SR <= {dividend_abs_ext[15:7], 8'd0};

                        cnt <= 4'd0;
                        state <= DIVIDE;
                    end
                end

                DIVIDE: begin
                    // Each clock cycle performs one radix-2 iteration

                    // Shift left 1 and insert 0 at LSB
                    // Update remainder and quotient bit based on subtraction result
                    SR <= {remainder_next, SR_shifted[7:1], quotient_bit};

                    cnt <= cnt + 1'b1;

                    if (cnt == 4'd7) begin
                        // Division done after 8 iterations (cnt counts from 0)
                        state <= IDLE;
                        res_valid <= 1'b1;

                        // Extract quotient and remainder before sign correction
                        reg [7:0] quotient_unsigned;
                        reg [7:0] remainder_unsigned;

                        quotient_unsigned = {SR_shifted[7:1], quotient_bit};
                        remainder_unsigned = remainder_next[8:1]; // remainder is 8 bits, take MSB to LSB (discard LSB bit from remainder_next[0]?)

                        // The remainder register is upper 9 bits: [8:0].
                        // But remainder is 8 bits output, so usually the top 8 bits are kept. According to problem, remainder is upper 8 bits.
                        // Use remainder_next[8:1] as remainder (drop least significant bit)
                        // This matches that in division the remainder can be 8 bits.

                        // Sign correct quotient
                        if (sign_quotient) begin
                            quotient_unsigned = (~quotient_unsigned + 1'b1);
                        end

                        // Sign correct remainder
                        if (sign_remainder) begin
                            remainder_unsigned = (~remainder_unsigned + 1'b1);
                        end

                        result <= {remainder_unsigned, quotient_unsigned};
                    end
                end

                default: state <= IDLE;
            endcase

            // Clear res_valid if new operation requested and previous result valid
            if (res_valid && opn_valid) begin
                res_valid <= 1'b0;
            end
        end
    end

endmodule