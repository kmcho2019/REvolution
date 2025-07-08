module radix2_div(
    input clk,
    input rst,
    input sign,               // 1: signed division, 0: unsigned division
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output reg res_valid,
    output reg [15:0] result  // {remainder[7:0], quotient[7:0]}
);

    // Internal signals
    reg [15:0] SR;            // Shift register: upper 9 bits remainder + lower 7 bits quotient, but here we keep 16 bits for ease
    reg [7:0] ABS_DIVIDEND;
    reg [7:0] ABS_DIVISOR;
    reg [7:0] NEG_DIVISOR;    // Two's complement of ABS_DIVISOR
    reg [3:0] cnt;            // 4-bit counter (0 to 8)
    reg start_cnt;

    reg sign_quotient;        // Sign of quotient
    reg sign_remainder;       // Sign of remainder (same as dividend sign for signed division)

    wire [8:0] sub_res;       // subtraction result with carry
    wire borrow_out;

    // Extract remainder and quotient from SR during operation:
    // The remainder will be in bits [15:8], quotient in [7:0] (final)
    // But during operation, SR is 16 bits, shifting left by 1 each iteration

    // Prepare absolute values and signs
    wire dividend_sign = sign ? dividend[7] : 1'b0;
    wire divisor_sign  = sign ? divisor[7]  : 1'b0;

    wire [7:0] dividend_abs = dividend_sign ? (~dividend + 1) : dividend;
    wire [7:0] divisor_abs  = divisor_sign ? (~divisor + 1) : divisor;

    // Subtraction: SR[15:8] - ABS_DIVISOR (9-bit subtraction)
    wire [8:0] sr_remainder = {1'b0, SR[15:8]};
    wire [8:0] neg_divisor_9b = {1'b1, ~ABS_DIVISOR} + 9'b1; // two's complement as 9-bit negative divisor

    assign sub_res = sr_remainder + neg_divisor_9b;
    assign borrow_out = ~sub_res[8]; // borrow if MSB is 0, carry if 1

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            SR <= 16'b0;
            cnt <= 0;
            start_cnt <= 1'b0;
            res_valid <= 1'b0;
            result <= 16'b0;
            ABS_DIVIDEND <= 8'b0;
            ABS_DIVISOR <= 8'b0;
            NEG_DIVISOR <= 8'b0;
            sign_quotient <= 1'b0;
            sign_remainder <= 1'b0;
        end else begin
            if (opn_valid && !res_valid) begin
                // Capture inputs, prepare abs and signs
                ABS_DIVIDEND <= dividend_abs;
                ABS_DIVISOR <= divisor_abs;
                NEG_DIVISOR <= (~divisor_abs) + 1'b1;

                sign_quotient <= dividend_sign ^ divisor_sign;
                sign_remainder <= dividend_sign;

                // Initialize SR with absolute dividend shifted left by 1
                // This is: dividend_abs in bits [14:7], bit 0 = 0 (LSB)
                // Let's place dividend_abs in bits [14:7] and bit 0 zero:
                // Actually, per instruction: SR initialized with absolute dividend shifted left by 1 bit
                SR <= {dividend_abs, 8'b0} << 1;

                cnt <= 4'd1;
                start_cnt <= 1'b1;
                res_valid <= 1'b0;
            end else if (start_cnt) begin
                if (cnt == 4'd8) begin
                    // Division complete
                    start_cnt <= 1'b0;
                    cnt <= 0;

                    // After division, SR has the remainder in upper bits and quotient in lower bits:
                    // Quotient in SR[7:0], remainder in SR[15:8]

                    // Adjust quotient sign if signed division
                    reg [7:0] final_quotient;
                    reg [7:0] final_remainder;

                    // Use localvars here to avoid synthesis warnings
                    final_quotient = SR[7:0];
                    final_remainder = SR[15:8];

                    if (sign) begin
                        // Adjust quotient sign
                        if (sign_quotient) begin
                            final_quotient = (~final_quotient) + 1'b1;
                        end
                        // Adjust remainder sign: remainder sign same as dividend
                        if (sign_remainder) begin
                            final_remainder = (~final_remainder) + 1'b1;
                        end
                    end

                    result <= {final_remainder, final_quotient};
                    res_valid <= 1'b1;
                end else begin
                    // Iterative division step
                    // Check subtraction result: if no borrow (borrow_out==1), update SR remainder to sub_res and shift in 1
                    // else, shift in 0
                    if (borrow_out) begin
                        // remainder = sub_res[7:0], shift left 1 and insert 1 in LSB
                        SR <= {sub_res[7:0], SR[7:1], 1'b1};
                    end else begin
                        // remainder unchanged, shift left 1 and insert 0 in LSB
                        SR <= {SR[14:0], 1'b0};
                    end
                    cnt <= cnt + 1'b1;
                end
            end else if (res_valid) begin
                // Wait for result to be consumed, user clears res_valid externally (not specified in problem)
                // So we keep res_valid asserted until reset or new operation
                // Optionally, could clear res_valid on new opn_valid, but problem states res_valid managed by reset and counter
                // So do nothing here
            end
        end
    end

endmodule