module radix2_div (
    input  wire        clk,
    input  wire        rst,
    input  wire        sign,
    input  wire [7:0]  dividend,
    input  wire [7:0]  divisor,
    input  wire        opn_valid,
    output reg         res_valid,
    output reg [15:0]  result
);

    // Internal registers
    reg [16:0] SR;       // Shift register: holds remainder and quotient bits, extra bit for shift in subtraction result
    reg [7:0]  NEG_DIVISOR; // Negated divisor absolute value
    reg [3:0]  cnt;      // Counter for division iterations (needs to count to 8)
    reg        start_cnt;

    // Internal signals for sign handling and absolute values
    reg        dividend_sign;
    reg        divisor_sign;

    reg [7:0]  abs_dividend;
    reg [7:0]  abs_divisor;

    // Intermediate subtraction result and carry out
    wire [8:0] sub_res;
    wire       sub_carry_out; // carry out is the MSB of sub_res

    // Extract upper 9 bits of SR for subtraction (current remainder bits + MSB zero)
    wire [8:0] SR_upper = {SR[16], SR[15:8]}; // 9 bits: remainder + MSB sign extension for subtraction

    // Calculate subtraction: SR_upper - NEG_DIVISOR (which is the negated divisor absolute)
    assign sub_res = SR_upper + {1'b0, NEG_DIVISOR}; // addition because NEG_DIVISOR is negated divisor abs
    assign sub_carry_out = sub_res[8]; // MSB is carry out

    // Helper function: absolute value and sign extraction
    function [7:0] abs_val;
        input [7:0] val;
        input       sign_flag;
        begin
            if(sign_flag && val[7])
                abs_val = (~val) + 1'b1;
            else
                abs_val = val;
        end
    endfunction

    // Sign extraction
    always @(*) begin
        dividend_sign = sign ? dividend[7] : 1'b0;
        divisor_sign  = sign ? divisor[7]  : 1'b0;

        abs_dividend = abs_val(dividend, sign);
        abs_divisor  = abs_val(divisor, sign);
    end

    // Negated divisor absolute value (2's complement)
    always @(*) begin
        NEG_DIVISOR = (~abs_divisor) + 1'b1;
    end

    // Division process
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            SR        <= 17'd0;
            cnt       <= 4'd0;
            start_cnt <= 1'b0;
            res_valid <= 1'b0;
            result    <= 16'd0;
        end else begin
            // Start operation if opn_valid and not busy
            if (opn_valid && !res_valid && !start_cnt) begin
                // Initialize SR with dividend abs shifted left by 1 bit (16 bits: remainder(8)+quotient(8)+1 extra)
                // Left shift by 1 means SR[16:9]=0 remainder, SR[8:1]=abs_dividend, SR[0]=0
                SR        <= {9'd0, abs_dividend, 1'b0};
                cnt       <= 4'd1;
                start_cnt <= 1'b1;
                res_valid <= 1'b0;
                result    <= 16'd0;
            end else if (start_cnt) begin
                if (cnt == 4'd8) begin
                    // Division complete, clear counter and start_cnt
                    start_cnt <= 1'b0;
                    cnt       <= 4'd0;

                    // SR now contains remainder and quotient, remainder in upper 8 bits, quotient in lower 8 bits

                    // Adjust quotient and remainder signs if signed division
                    // quotient_sign = dividend_sign ^ divisor_sign
                    // remainder_sign = dividend_sign
                    // We only adjust if signed==1

                    // Extract remainder and quotient before sign correction
                    reg [7:0] quotient_raw;
                    reg [7:0] remainder_raw;
                    reg [7:0] quotient_signed;
                    reg [7:0] remainder_signed;

                    quotient_raw = SR[7:0];
                    remainder_raw = SR[16:9];

                    if (sign) begin
                        // quotient sign
                        if (dividend_sign ^ divisor_sign) begin
                            quotient_signed = (~quotient_raw) + 1'b1;
                        end else begin
                            quotient_signed = quotient_raw;
                        end

                        // remainder sign
                        if (dividend_sign) begin
                            remainder_signed = (~remainder_raw) + 1'b1;
                        end else begin
                            remainder_signed = remainder_raw;
                        end
                    end else begin
                        quotient_signed = quotient_raw;
                        remainder_signed = remainder_raw;
                    end

                    // Prepare output result: remainder in upper 8 bits, quotient in lower 8 bits
                    result <= {remainder_signed, quotient_signed};
                    res_valid <= 1'b1;

                end else begin
                    // Continue division iterations

                    // If subtraction result carry out is 1, remainder >= divisor, so subtract
                    // Insert quotient bit = 1
                    // Else quotient bit = 0 and restore remainder
                    if (sub_carry_out == 1'b1) begin
                        // subtraction successful, set quotient bit to 1
                        // Shift SR left by 1 bit and put 1 at LSB
                        SR <= {sub_res[7:0], SR[7:0], 1'b1};
                    end else begin
                        // subtraction unsuccessful, restore remainder, quotient bit = 0
                        // Shift SR left by 1 bit and put 0 at LSB
                        SR <= {SR[15:0], 1'b0};
                    end

                    cnt <= cnt + 4'd1;
                end
            end else if (res_valid && !opn_valid) begin
                // Result has been consumed, clear res_valid to accept new operation
                res_valid <= 1'b0;
            end
        end
    end

endmodule