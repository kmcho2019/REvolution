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

    // States definition
    localparam IDLE   = 2'd0;
    localparam DIVIDE = 2'd1;
    localparam DONE   = 2'd2;

    reg [1:0] state, next_state;

    // Internal registers for absolute values and signs
    reg [7:0] dividend_abs, divisor_abs;
    reg dividend_sign, divisor_sign;

    // Shift register: [16:8] remainder (9 bits, sign extended for trial), [7:0] partial quotient
    reg [16:0] SR;

    // Counter for division iterations (max 8)
    reg [3:0] cnt;

    // Trial subtraction signals
    wire [8:0] remainder_trial;    // 9-bit remainder (includes sign bit)
    wire [8:0] subtract_res;       // trial remainder - divisor_abs
    wire       subtract_nonneg;    // subtraction result non-negative flag

    // Registers to hold quotient and remainder before sign correction
    reg [7:0] quotient_raw;
    reg [7:0] remainder_raw;

    // Final sign-corrected results
    reg [7:0] quotient_final;
    reg [7:0] remainder_final;

    // Functions for absolute and negate (two's complement)
    function [7:0] abs8(input [7:0] val);
        begin
            abs8 = val[7] ? (~val + 1'b1) : val;
        end
    endfunction

    function [7:0] neg8(input [7:0] val);
        begin
            neg8 = ~val + 1'b1;
        end
    endfunction

    // Extract the upper 9 bits of SR for remainder trial (sign-extended)
    // SR[16] is the sign bit of remainder trial (since remainder is 8 bits plus 1 bit for trial shift)
    assign remainder_trial = {SR[16], SR[16:9]} << 1 | SR[8];

    // Subtract divisor_abs from remainder_trial
    assign subtract_res = remainder_trial - {1'b0, divisor_abs};

    // Check if subtract_res >= 0 (sign bit == 0)
    assign subtract_nonneg = (subtract_res[8] == 1'b0);

    // Sequential logic: state machine and division operation
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state         <= IDLE;
            res_valid     <= 1'b0;
            result        <= 16'd0;
            dividend_abs  <= 8'd0;
            divisor_abs   <= 8'd0;
            dividend_sign <= 1'b0;
            divisor_sign  <= 1'b0;
            SR            <= 17'd0;
            cnt           <= 4'd0;
            quotient_raw  <= 8'd0;
            remainder_raw <= 8'd0;
            quotient_final<= 8'd0;
            remainder_final<=8'd0;
        end else begin
            case (state)
                IDLE: begin
                    res_valid <= 1'b0;
                    if (opn_valid) begin
                        // Compute absolute values and signs if signed division
                        if (sign) begin
                            dividend_sign <= dividend[7];
                            divisor_sign  <= divisor[7];
                            dividend_abs  <= abs8(dividend);
                            divisor_abs   <= abs8(divisor);
                        end else begin
                            dividend_sign <= 1'b0;
                            divisor_sign  <= 1'b0;
                            dividend_abs  <= dividend;
                            divisor_abs   <= divisor;
                        end
                        // Initialize SR: remainder = 0 (9 bits), quotient = dividend_abs shifted left 1 bit with LSB=0
                        // The dividend_abs is loaded into lower 8 bits and we add an LSB zero at bit 0 for next quotient bit
                        // We'll load SR as {9'd0, dividend_abs, 1'b0} = 9+8+1=18 bits, but SR is 17 bits, so assign properly:
                        // SR[16:9] = 0; SR[8:1] = dividend_abs[7:0]; SR[0] = 0;
                        SR <= {9'd0, dividend_abs, 1'b0};
                        cnt <= 4'd0;

                        // If divisor_abs == 0, go directly to DONE for division by zero handling
                        if (divisor_abs == 8'd0) begin
                            state <= DONE;
                        end else begin
                            state <= DIVIDE;
                        end
                    end
                end

                DIVIDE: begin
                    // Perform one division iteration per clock
                    if (cnt < 8) begin
                        // Shift SR left by 1 bit first (shifting remainder and quotient)
                        // Then conditionally update remainder portion according to subtraction result
                        // Shift SR left by 1 and insert quotient bit:
                        // If subtract_nonneg is 1:
                        //  remainder <= subtract_res[7:0] (lower 8 bits)
                        //  quotient bit = 1
                        // else
                        //  remainder unchanged (just shifted)
                        //  quotient bit = 0

                        if (subtract_nonneg) begin
                            // Successful subtraction: new remainder = subtract_res[7:0]
                            // Shift quotient left by 1, set LSB = 1
                            // So SR next = {subtract_res[7:0], SR[7:0], 1'b1}
                            // But shift left by 1 before updating:
                            // We implement by: 
                            // Take current remainder trial, subtract divisor, and shift left quotient + insert 1
                            // To do this correctly, we build next_SR:

                            // next SR is constructed as:
                            // Upper 9 bits = subtract_res (9 bits)
                            // Lower 8 bits = SR[7:1] shifted left 1 bit to make room for new quotient bit
                            // The new quotient bit is 1 (LSB)

                            // Implementation detail:
                            // But we only have 17 bits total, so to shift left 1:
                            // SR <= {subtract_res[7:0], SR[7:1], 1'b1};

                            // However, note SR[7:1] is 7 bits; SR[7:0] is 8 bits; plus 1 bit = 16 bits, need to check carefully.

                            // Instead of complicated bit slicing, perform SR shift left 1 and insert quotient bit:
                            // We can do:
                            // temp_SR = SR << 1
                            // Set LSB = quotient bit (1 or 0)
                            // Then if subtract_nonneg, update remainder portion in upper bits to subtract_res[7:0]
                            // That is:

                            // SR next = {subtract_res[7:0], temp_SR[7:0], 1'b1}

                            // More straightforward is:
                            // Shift SR left 1 bit, insert quotient bit at LSB
                            // Update upper 8 bits (remainder) = subtract_res[7:0]

                            // To avoid confusion, let's implement a temporary variable to hold next SR:

                            reg [16:0] SR_temp;
                            SR_temp = (SR << 1);
                            SR_temp[0] = 1'b1; // set quotient bit to 1

                            // Replace remainder bits [16:9] with subtract_res[7:0] and sign bit = 0 (because subtract_nonneg)
                            // So SR_temp[16:9] = {sign=0, subtract_res[7:0]}
                            // Because subtract_res is 9 bits signed number, if subtract_nonneg =1, MSB = 0 (non-negative)
                            // So sign bit 0
                            SR_temp[16:9] = {1'b0, subtract_res[7:0]};

                            SR <= SR_temp;
                        end else begin
                            // Unsuccessful subtraction: restore remainder, quotient bit = 0
                            // Shift SR left by 1, insert quotient bit = 0
                            SR <= (SR << 1);
                            // LSB automatically 0 by shift left
                        end

                        cnt <= cnt + 1'b1;

                    end else begin
                        // Finished 8 iterations
                        quotient_raw  <= SR[7:0];     // lower 8 bits of SR: quotient
                        remainder_raw <= SR[16:9];    // upper 8 bits of SR: remainder
                        state <= DONE;
                    end
                end

                DONE: begin
                    // Handle division by zero
                    if (divisor_abs == 8'd0) begin
                        quotient_final  <= 8'hFF;        // typically max unsigned value or special value
                        remainder_final <= dividend_abs; // remainder is dividend_abs
                    end else if (sign) begin
                        // Signed division: correct sign of quotient and remainder
                        // Quotient sign = dividend_sign XOR divisor_sign
                        if (dividend_sign ^ divisor_sign)
                            quotient_final <= neg8(quotient_raw);
                        else
                            quotient_final <= quotient_raw;

                        // Remainder sign = dividend_sign
                        if (dividend_sign)
                            remainder_final <= neg8(remainder_raw);
                        else
                            remainder_final <= remainder_raw;
                    end else begin
                        // Unsigned: no sign correction
                        quotient_final  <= quotient_raw;
                        remainder_final <= remainder_raw;
                    end

                    // Output final result
                    result <= {remainder_final, quotient_final};
                    res_valid <= 1'b1;

                    // Wait for opn_valid to go low to return to IDLE
                    if (!opn_valid) begin
                        res_valid <= 1'b0;
                        state <= IDLE;
                    end
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule