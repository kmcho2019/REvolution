module radix2_div (
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output reg res_valid,
    output reg [15:0] result  // [15:8]: remainder, [7:0]: quotient
);

    // Internal signals and registers
    reg [8:0] SR;       // Shift register: 9 bits to hold remainder + next quotient bit
    reg [7:0] NEG_DIVISOR;  // Negative divisor for subtraction
    reg [3:0] cnt;      // 4-bit counter, count 1 to 8
    reg start_cnt;      // Start signal for counting / division process

    reg dividend_sign, divisor_sign; // Sign bits for dividend and divisor
    reg [7:0] abs_dividend, abs_divisor; // Absolute values of dividend and divisor

    reg [7:0] quotient;
    reg [7:0] remainder;

    // Wires for subtraction
    wire [8:0] sub_res;
    wire sub_cout;

    // Convert dividend and divisor to absolute values and extract signs when opn_valid
    // For signed operation only
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            dividend_sign <= 1'b0;
            divisor_sign <= 1'b0;
            abs_dividend <= 8'd0;
            abs_divisor <= 8'd0;
        end else if (opn_valid && !res_valid) begin
            if (sign) begin
                dividend_sign <= dividend[7];
                divisor_sign <= divisor[7];
                abs_dividend <= dividend[7] ? (~dividend + 1) : dividend;
                abs_divisor <= divisor[7] ? (~divisor + 1) : divisor;
            end else begin
                dividend_sign <= 1'b0;
                divisor_sign <= 1'b0;
                abs_dividend <= dividend;
                abs_divisor <= divisor;
            end
        end
    end

    // NEG_DIVISOR = -abs_divisor
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            NEG_DIVISOR <= 8'd0;
        end else if (opn_valid && !res_valid) begin
            NEG_DIVISOR <= (~abs_divisor) + 1;
        end
    end

    // Subtraction: SR[8:1] + NEG_DIVISOR (both 8-bit) => 9 bits result
    // SR[8:1] holds current remainder bits (8 bits), LSB SR[0] is quotient bit shift-in
    assign {sub_cout, sub_res} = {1'b0, SR[8:1]} + {1'b0, NEG_DIVISOR};

    // Division process state machine
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            SR <= 9'd0;
            cnt <= 4'd0;
            start_cnt <= 1'b0;
            res_valid <= 1'b0;
            result <= 16'd0;
            quotient <= 8'd0;
            remainder <= 8'd0;
        end else begin
            if (opn_valid && !res_valid) begin
                // Start new division
                // Initialize SR with abs_dividend shifted left by 1
                SR <= {abs_dividend, 1'b0};
                cnt <= 4'd1;
                start_cnt <= 1'b1;
                res_valid <= 1'b0;
            end else if (start_cnt) begin
                // Division steps
                if (cnt == 4'd8) begin
                    // Final cycle done
                    start_cnt <= 1'b0;
                    cnt <= 4'd0;
                    // Final quotient and remainder extraction
                    // SR[8:1] is remainder, SR[0] is last quotient bit (already shifted in)

                    // Quotient is in SR[7:0], remainder in SR[8:1]
                    remainder <= SR[8:1];
                    quotient <= SR[7:0];

                    // Adjust quotient and remainder signs if signed division
                    if (sign) begin
                        // Quotient sign = dividend_sign XOR divisor_sign
                        // Remainder sign = dividend_sign
                        if (dividend_sign ^ divisor_sign) begin
                            quotient <= (~SR[7:0] + 1);
                        end
                        if (dividend_sign) begin
                            remainder <= (~SR[8:1] + 1);
                        end
                    end

                    result <= {remainder, quotient};
                    res_valid <= 1'b1;
                end else begin
                    // Intermediate steps: do subtraction and update SR and cnt
                    cnt <= cnt + 1;

                    if (!sub_cout) begin
                        // If subtraction result MSB is 0 (meaning SR[8] bit after addition is 0),
                        // set quotient bit = 1 and update remainder with subtraction result
                        // shift left SR and insert 1 at LSB
                        SR <= {sub_res[7:0], 1'b1};
                    end else begin
                        // If subtraction result MSB is 1 (borrow), keep remainder as is,
                        // shift left SR and insert 0 at LSB
                        SR <= {SR[7:0], 1'b0};
                    end
                end
            end else if (res_valid && !opn_valid) begin
                // Wait for result to be consumed (opn_valid low), then clear res_valid
                res_valid <= 1'b0;
            end
        end
    end

endmodule