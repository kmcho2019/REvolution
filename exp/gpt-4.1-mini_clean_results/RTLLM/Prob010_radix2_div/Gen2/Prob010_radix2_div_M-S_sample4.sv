module radix2_div(
    input              clk,
    input              rst,
    input              sign,         // 1 for signed division, 0 for unsigned
    input      [7:0]   dividend,
    input      [7:0]   divisor,
    input              opn_valid,
    output reg         res_valid,
    output reg [15:0]  result         // {remainder[7:0], quotient[7:0]}
);

    reg [16:0] SR;              // Shift register: remainder(8 bits +1) + quotient(8 bits)
    reg [7:0] divisor_abs;
    reg [15:0] dividend_abs_ext;
    reg [3:0] cnt;
    reg working;

    reg dividend_neg;
    reg divisor_neg;
    reg sign_quotient;
    reg sign_remainder;

    // Wires for subtraction
    wire [9:0] sub_res;
    wire sub_borrow;

    // remainder is upper 9 bits of SR
    wire [8:0] remainder_part = SR[16:8];

    assign {sub_borrow, sub_res} = {1'b0, remainder_part} - {1'b0, divisor_abs};

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            SR <= 17'd0;
            divisor_abs <= 8'd0;
            dividend_abs_ext <= 16'd0;
            cnt <= 4'd0;
            working <= 1'b0;
            res_valid <= 1'b0;
            result <= 16'd0;
            dividend_neg <= 1'b0;
            divisor_neg <= 1'b0;
            sign_quotient <= 1'b0;
            sign_remainder <= 1'b0;
        end else begin
            if (opn_valid && !working && !res_valid) begin
                // Start division operation: prepare absolute values and sign info
                if (sign) begin
                    dividend_neg <= dividend[7];
                    divisor_neg <= divisor[7];
                    divisor_abs <= divisor[7] ? (~divisor + 1) : divisor;
                    dividend_abs_ext <= (dividend[7] ? (~dividend + 1) : dividend) << 8;
                    sign_quotient <= dividend[7] ^ divisor[7];
                    sign_remainder <= dividend[7];
                end else begin
                    dividend_neg <= 1'b0;
                    divisor_neg <= 1'b0;
                    divisor_abs <= divisor;
                    dividend_abs_ext <= dividend << 8;
                    sign_quotient <= 1'b0;
                    sign_remainder <= 1'b0;
                end

                // Initialize shift register: remainder = dividend_abs shifted by 8 bits, quotient zero
                SR <= {dividend_abs_ext[15:7], 8'd0}; // 9 bits remainder + 8 bits quotient =17 bits

                cnt <= 4'd0;
                working <= 1'b1;
                res_valid <= 1'b0;
                result <= 16'd0;
            end else if (working) begin
                // Shift left SR by 1
                SR <= {SR[15:0], 1'b0};

                // After shift, check if remainder >= divisor_abs
                // The subtraction output is combinational based on shifted SR (updated next cycle)
                // So perform subtraction and update SR at next posedge

                // We must use temporary registers to update SR accordingly on next cycle
                // Use sequential logic on next clock:
                // The logic to update SR happens here using previous SR values

                // We use the subtraction result of current remainder_part after shift (which was computed combinationally)

                // To implement this correctly, we need a small state machine or extra reg to hold the subtraction result for one cycle

                // For simplicity, pipeline the logic:

                // On current clock:
                // - shift SR left (done above)
                // - then check sub_borrow and update remainder and quotient bit accordingly

                // Because SR is updated on posedge, sub_borrow is based on previous SR which is not correct here

                // Solution: delay the subtraction by one clock cycle using an intermediate register to hold shifted SR for subtraction

                // Let's implement this with a 2-stage pipeline:

            end

            // To implement the subtraction and SR update properly:
            // We need a separate register to hold SR after shift and use it to perform subtraction in next cycle

        end
    end

    // Implementing the division cycle logic with a pipeline requires a little more logic outside always block:

    // Let's use a simple state machine approach for step by step clarity:

    reg [16:0] SR_shifted;
    reg [8:0] remainder_after_shift;
    reg subtraction_ready;
    reg [3:0] cnt_next;
    reg working_next;
    reg res_valid_next;
    reg [15:0] result_next;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            SR_shifted <= 17'd0;
            subtraction_ready <= 1'b0;
            cnt_next <= 4'd0;
            working_next <= 1'b0;
            res_valid_next <= 1'b0;
            result_next <= 16'd0;
        end else begin
            if (opn_valid && !working && !res_valid) begin
                SR_shifted <= 17'd0;
                subtraction_ready <= 1'b0;
                cnt_next <= 4'd0;
                working_next <= 1'b1;
                res_valid_next <= 1'b0;
                result_next <= 16'd0;
            end else if (working) begin
                SR_shifted <= {SR[15:0], 1'b0}; // shift left by 1
                subtraction_ready <= 1'b1;
                cnt_next <= cnt + 1'b1;
                working_next <= (cnt != 4'd7);
                res_valid_next <= (cnt == 4'd7);

                if (subtraction_ready) begin
                    // perform subtraction
                    if (!sub_borrow) begin
                        // remainder >= divisor_abs, update remainder and set quotient bit
                        SR <= {sub_res[8:0], SR_shifted[7:1], 1'b1};
                    end else begin
                        // remainder < divisor_abs, restore remainder and clear quotient bit
                        SR <= {SR_shifted[16:9], SR_shifted[7:0], 1'b0};
                    end
                end else begin
                    // first cycle after start, just shift SR (already assigned in always posedge)
                    SR <= SR;
                end

                if (cnt == 4'd7) begin
                    // Division finished, apply sign correction
                    reg [7:0] quotient_unsigned;
                    reg [7:0] remainder_unsigned;
                    quotient_unsigned = SR[7:0];
                    remainder_unsigned = SR[16:9];

                    if (sign && sign_quotient)
                        quotient_unsigned = (~quotient_unsigned + 1);
                    if (sign && sign_remainder)
                        remainder_unsigned = (~remainder_unsigned + 1);

                    result <= {remainder_unsigned, quotient_unsigned};
                end
            end

            // update control signals
            cnt <= cnt_next;
            working <= working_next;
            res_valid <= res_valid_next;

            // Clear res_valid when a new operation starts
            if (res_valid && opn_valid) begin
                res_valid <= 1'b0;
            end
        end
    end

endmodule