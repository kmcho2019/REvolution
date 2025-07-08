module radix2_div (
    input              clk,
    input              rst,
    input              sign,
    input      [7:0]   dividend,
    input      [7:0]   divisor,
    input              opn_valid,
    output reg         res_valid,
    output reg [15:0]  result
);

    // Internal registers
    reg [8:0] SR;             // 9-bit shift register: remainder(8 bits) + quotient(1 bit)
    reg [7:0] NEG_DIVISOR;    // negated divisor (absolute value)
    reg [3:0] cnt;            // count 1 to 8
    reg start_cnt;            // indicates division in progress

    // Registers to hold absolute values and signs
    reg [7:0] abs_dividend;
    reg [7:0] abs_divisor;
    reg dividend_sign;
    reg divisor_sign;

    // Temporary signals for subtraction
    wire [8:0] sub_res;
    wire       sub_carry_out;

    // Determine absolute values and signs
    // Signed extension to 9 bits for subtraction
    wire [8:0] abs_dividend_9 = {1'b0, abs_dividend};
    wire [8:0] abs_divisor_9  = {1'b0, abs_divisor};

    // Subtraction: SR[8:0] + NEG_DIVISOR (two's complement)
    // We compute SR + NEG_DIVISOR, where NEG_DIVISOR = ~abs_divisor + 1
    // Actually NEG_DIVISOR stored as 8 bits, need 9 bits with sign extension for subtraction
    wire [8:0] divisor_9 = {1'b0, abs_divisor};
    wire [8:0] neg_divisor_9 = ~divisor_9 + 9'b1;

    assign sub_res = SR + neg_divisor_9;
    assign sub_carry_out = ~sub_res[8]; 
    // carry_out logic: if sub_res[8] is 0, subtraction did not borrow => sub_carry_out=1

    // State machine on clk
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            res_valid   <= 1'b0;
            cnt         <= 4'b0;
            start_cnt   <= 1'b0;
            SR          <= 9'b0;
            NEG_DIVISOR <= 8'b0;
            abs_dividend <= 8'b0;
            abs_divisor <= 8'b0;
            dividend_sign <= 1'b0;
            divisor_sign  <= 1'b0;
            result      <= 16'b0;
        end else begin
            // Start division on opn_valid high and res_valid low
            if (opn_valid && !res_valid && !start_cnt) begin
                // Determine signs and absolute values
                if (sign) begin
                    dividend_sign <= dividend[7];
                    divisor_sign  <= divisor[7];
                    abs_dividend  <= dividend[7] ? (~dividend + 8'b1) : dividend;
                    abs_divisor   <= divisor[7]  ? (~divisor + 8'b1)  : divisor;
                end else begin
                    dividend_sign <= 1'b0;
                    divisor_sign  <= 1'b0;
                    abs_dividend  <= dividend;
                    abs_divisor   <= divisor;
                end

                // Initialize SR with absolute dividend shifted left by 1 (9 bits)
                SR <= {abs_dividend, 1'b0};

                // NEG_DIVISOR: negated absolute divisor (8 bits)
                NEG_DIVISOR <= ~abs_divisor + 8'b1;

                // Initialize counter and start flag
                cnt       <= 4'd1;
                start_cnt <= 1'b1;

                // Clear result valid
                res_valid <= 1'b0;
            end else if (start_cnt) begin
                // Division in progress
                if (cnt == 4'd8) begin
                    // Last iteration complete
                    start_cnt <= 1'b0;
                    cnt       <= 4'b0;

                    // Update SR with final quotient and remainder
                    // SR[8:1] remainder, SR[0] quotient bit
                    // After last iteration, remainder is in SR[8:1], quotient in SR[0]+previous bits

                    // SR now has: remainder in bits [8:1], quotient bit in bit 0
                    // But quotient bits accumulated in SR LSBs over iterations,
                    // After 8 iterations, SR[7:0] is quotient, SR[8:1] is remainder shifted for next step
                    // We must reconstruct quotient and remainder

                    // Actually, quotient accumulated in SR lower bits over shifts
                    // We must shift SR right by 1 to get quotient in lower 8 bits, remainder in bits [8:1]
                    // So final:
                    // remainder = SR[8:1]
                    // quotient  = SR[0] + previously accumulated bits shifted in each step

                    // Actually, we shift quotient bits in SR LSBs, so after 8 cycles:
                    // SR[8:1] remainder, SR[0] last quotient bit
                    // But quotient bits are in SR[7:0], remainder in SR[8:1] (overlapping)
                    // To correct, on each step we shift left with carry_out to insert quotient bit

                    // We will keep SR as 9 bits: remainder(8 bits) + quotient bit in LSB
                    // So after completion, quotient is in SR[7:0], remainder in SR[8:1]

                    // Compute sign correction for quotient and remainder
                    reg [7:0] quotient_tmp;
                    reg [7:0] remainder_tmp;

                    quotient_tmp = SR[7:0];
                    remainder_tmp = SR[8:1];

                    // Correct quotient sign
                    if (sign && (dividend_sign ^ divisor_sign)) begin
                        quotient_tmp = (~quotient_tmp + 8'b1);
                    end

                    // Correct remainder sign: same as dividend sign
                    if (sign && dividend_sign) begin
                        remainder_tmp = (~remainder_tmp + 8'b1);
                    end

                    // Pack result: remainder in upper 8 bits, quotient in lower 8 bits
                    result <= {remainder_tmp, quotient_tmp};

                    res_valid <= 1'b1;

                end else begin
                    // Intermediate iteration
                    cnt <= cnt + 4'd1;

                    // Perform subtraction SR + NEG_DIVISOR (9 bits)
                    // If no borrow (carry_out=1), update SR with sub_res shifted left + 1
                    // else shift SR left + 0 (restore)

                    if (sub_carry_out) begin
                        // subtraction successful
                        // shift left by 1, insert 1 in LSB
                        SR <= {sub_res[7:0], 1'b1};
                    end else begin
                        // subtraction failed
                        // shift left by 1, insert 0 in LSB
                        SR <= {SR[7:0], 1'b0};
                    end

                end
            end else begin
                // When no division in progress and no new opn_valid, clear res_valid after one cycle
                if (res_valid) begin
                    res_valid <= 1'b0;
                end
            end
        end
    end

endmodule