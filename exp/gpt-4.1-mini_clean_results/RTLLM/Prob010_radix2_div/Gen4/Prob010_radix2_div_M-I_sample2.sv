module radix2_div(
    input              clk,
    input              rst,
    input              sign,         // 1 for signed division, 0 for unsigned
    input      [7:0]   dividend,
    input      [7:0]   divisor,
    input              opn_valid,
    input              res_ready,    // To clear res_valid when result consumed
    output reg         res_valid,
    output reg [15:0]  result         // {remainder[7:0], quotient[7:0]}
);

    // Shift register:
    // bits [16:8] hold remainder (9 bits)
    // bits [7:0] hold quotient (8 bits)
    reg [16:0] SR;

    reg [7:0] divisor_abs;
    reg [15:0] dividend_abs_ext; // absolute dividend shifted left 8 bits
    reg [3:0] cnt;
    reg working;

    reg dividend_neg, divisor_neg;
    reg sign_quotient, sign_remainder;

    // Intermediate wires for combinational subtraction
    wire [8:0] remainder_part = SR[16:8];
    wire [8:0] sub_res;
    wire sub_borrow;

    assign {sub_borrow, sub_res} = {1'b0, remainder_part} - {1'b0, divisor_abs};

    // State machine synchronous logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            SR           <= 17'd0;
            divisor_abs  <= 8'd0;
            dividend_abs_ext <= 16'd0;
            cnt          <= 4'd0;
            working      <= 1'b0;
            res_valid    <= 1'b0;
            result       <= 16'd0;
            dividend_neg <= 1'b0;
            divisor_neg  <= 1'b0;
            sign_quotient<= 1'b0;
            sign_remainder<= 1'b0;
        end else begin
            // Clear res_valid when result consumed
            if (res_valid && res_ready) begin
                res_valid <= 1'b0;
            end

            // Start division
            if (opn_valid && !working && !res_valid) begin
                // Signed operation: take absolute values, track signs
                if (sign) begin
                    dividend_neg <= dividend[7];
                    divisor_neg  <= divisor[7];
                    divisor_abs  <= divisor[7] ? (~divisor + 1'b1) : divisor;
                    dividend_abs_ext <= (dividend[7] ? (~dividend + 1'b1) : dividend) << 8;
                    sign_quotient <= dividend[7] ^ divisor[7];
                    sign_remainder <= dividend[7];
                end else begin
                    dividend_neg <= 1'b0;
                    divisor_neg  <= 1'b0;
                    divisor_abs  <= divisor;
                    dividend_abs_ext <= dividend << 8;
                    sign_quotient <= 1'b0;
                    sign_remainder <= 1'b0;
                end
                // Initialize shift register: remainder = dividend_abs shifted left by 8 bits, quotient=0
                SR <= {dividend_abs_ext[15:7], 8'd0}; // remainder: bits 16:8 = 9 bits, quotient: bits 7:0
                cnt <= 4'd0;
                working <= 1'b1;
                res_valid <= 1'b0;
                result <= 16'd0;
            end else if (working) begin
                // Division iteration
                // Shift SR left by 1 bit
                SR <= {SR[15:0], 1'b0};
                cnt <= cnt + 1'b1;

                // After shifting, conditionally subtract divisor_abs from remainder and update quotient LSB
                // We check subtraction result on previous remainder_part (before shift)
                // For proper timing, use the combinational subtraction from previous cycle's SR[16:8]

                // On next clock cycle, perform subtraction logic and update SR accordingly
                // To achieve this, create internal registers for subtraction step

                // Actually, we can implement subtraction and update of SR inside same clock domain,
                // but because SR is updated this cycle, subtraction must be calculated from previous SR state.

                // To solve this, we use a temporary reg to hold the updated SR after subtraction logic.

                // The subtraction result and quotient bit setting will be applied in next cycle by another always block or by registering intermediate signals.
            end else if (!working && !res_valid) begin
                // idle, waiting for opn_valid
            end

            // Here we need combinational logic to update SR after subtraction based on previous SR.

            // So we implement the subtraction and quotient bit setting combinationally from previous SR values:

            // But since SR is updated at clock edge, we must split this into a pipeline:
            // On one clock edge: shift left (done above)
            // On next clock edge: check subtraction and update SR accordingly

            // To implement that cleanly, we add a small state machine:

            // So improve design: add a pipeline stage between shift and subtraction update.

        end
    end

    // Separate combinational logic and pipeline registers for subtraction and quotient bit update
    reg [16:0] SR_shifted;
    reg [3:0] cnt_shifted;
    reg working_shifted;
    reg update_subtract;

    // Pipeline registers for subtraction logic (shifted SR delayed by 1 cycle)
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            SR_shifted <= 17'd0;
            cnt_shifted <= 4'd0;
            working_shifted <= 1'b0;
            update_subtract <= 1'b0;
        end else begin
            // Shifted SR updated when working division is in progress
            if (working) begin
                SR_shifted <= {SR[15:0], 1'b0}; // SR after shift left by 1
                cnt_shifted <= cnt + 1'b1;
                working_shifted <= working;
                update_subtract <= 1'b1;
            end else begin
                update_subtract <= 1'b0;
                working_shifted <= 1'b0;
                cnt_shifted <= cnt;
                SR_shifted <= SR_shifted;
            end
        end
    end

    // Perform subtraction and update quotient bit combinationally
    wire [8:0] remainder_shifted = SR_shifted[16:8];
    wire [8:0] sub_res_shifted;
    wire sub_borrow_shifted;
    assign {sub_borrow_shifted, sub_res_shifted} = {1'b0, remainder_shifted} - {1'b0, divisor_abs};

    // After subtraction, if no borrow, update remainder and set quotient bit to 1; else leave remainder and quotient bit 0
    reg [16:0] SR_updated;
    reg working_updated;
    reg res_valid_updated;
    reg [3:0] cnt_updated;
    reg [15:0] final_result;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            SR <= 17'd0;
            cnt <= 4'd0;
            working <= 1'b0;
            res_valid <= 1'b0;
            result <= 16'd0;
        end else begin
            if (update_subtract) begin
                if (!sub_borrow_shifted) begin
                    // remainder >= divisor_abs
                    // update remainder with sub_res_shifted
                    // set quotient LSB = 1
                    // quotient is bits [7:0], shift left done in previous stage, so set LSB=1
                    SR <= {sub_res_shifted[8:0], SR_shifted[7:1], 1'b1};
                end else begin
                    // remainder < divisor_abs
                    // leave remainder as is (after shift)
                    // quotient bit = 0
                    SR <= {SR_shifted[16:9], SR_shifted[7:0], 1'b0};
                end

                cnt <= cnt_shifted;
                // Check if division completed after 8 iterations
                if (cnt_shifted == 4'd8) begin
                    working <= 1'b0;
                    res_valid <= 1'b1;
                end else begin
                    working <= 1'b1;
                    res_valid <= 1'b0;
                end
            end

            // When division finished and res_valid is set, apply sign corrections and output result
            if (!working && res_valid) begin
                reg [7:0] quotient_unsigned;
                reg [7:0] remainder_unsigned;

                quotient_unsigned = SR[7:0];
                remainder_unsigned = SR[16:9];

                if (sign && sign_quotient)
                    quotient_unsigned = (~quotient_unsigned + 1'b1);
                if (sign && sign_remainder)
                    remainder_unsigned = (~remainder_unsigned + 1'b1);

                result <= {remainder_unsigned, quotient_unsigned};
            end

            // Clear res_valid when result consumed
            if (res_valid && res_ready) begin
                res_valid <= 1'b0;
            end

            // Start division on opn_valid
            if (opn_valid && !working && !res_valid) begin
                // This initialization already handled above in main always block
            end
        end
    end

endmodule