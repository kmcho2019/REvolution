module radix2_div(
    input              clk,
    input              rst,
    input              sign,         // 1 for signed division, 0 for unsigned
    input      [7:0]   dividend,
    input      [7:0]   divisor,
    input              opn_valid,
    input              res_ready,    // Added as per testbench expectation
    output reg         res_valid,
    output reg [15:0]  result         // {remainder[7:0], quotient[7:0]}
);

    // Shift register: [16:8] = remainder (9 bits), [7:0] = quotient (8 bits)
    reg [16:0] SR;
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
            // Clear res_valid if result is consumed
            if (res_valid && res_ready) begin
                res_valid <= 1'b0;
            end

            // Start operation if valid and not working and result not valid
            if (opn_valid && !working && !res_valid) begin
                // Prepare absolute values and signs
                if (sign) begin
                    dividend_neg <= dividend[7];
                    divisor_neg <= divisor[7];
                    divisor_abs <= divisor[7] ? (~divisor + 1'b1) : divisor;
                    dividend_abs_ext <= (dividend[7] ? (~dividend + 1'b1) : dividend) << 8; // remainder shifted by 8 bits
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

                // Initialize SR: remainder = dividend_abs shifted left 8 bits, quotient = 0
                SR <= {dividend_abs_ext[15:7], 8'd0}; // 9 bits remainder + 8 bits quotient =17 bits
                cnt <= 4'd0;
                working <= 1'b1;
                res_valid <= 1'b0;
                result <= 16'd0;
            end else if (working) begin
                // Perform one division iteration per clock
                // Shift SR left by 1
                SR <= {SR[15:0], 1'b0};

                // After shift, check if remainder >= divisor_abs by subtraction
                // If no borrow (sub_borrow==0), set quotient bit = 1 and update remainder
                // else leave quotient bit 0 and keep remainder unchanged (after shift)

                // Because SR updated this cycle, subtraction uses previous SR value;
                // so perform subtraction on remainder before shift.

                // The subtraction is from previous remainder, so must perform after shifting,
                // use nonblocking assignments carefully to reflect this in next cycle.

                // We'll handle the subtraction and update in the next cycle by latching the subtraction result in a reg.
            end else if (!working && !res_valid) begin
                // Idle state, do nothing
            end

            // To implement logic properly, introduce pipeline registers for subtraction step.

        end
    end

    // We need a step-by-step division FSM to handle the subtraction and update quotient bits correctly.
    // Implement FSM with separate sequential block for clarity.

    reg [16:0] SR_next;
    reg [3:0] cnt_next;
    reg working_next;
    reg res_valid_next;
    reg [7:0] quotient_unsigned;
    reg [7:0] remainder_unsigned;

    always @(*) begin
        SR_next = SR;
        cnt_next = cnt;
        working_next = working;
        res_valid_next = res_valid;

        if (working) begin
            // Shift left by 1 (temporarily)
            SR_next = {SR[15:0], 1'b0};
            cnt_next = cnt + 1'b1;

            // Check subtraction of divisor_abs from remainder part
            // remainder_part after shift = upper 9 bits of SR_next
            // We calculate the subtraction here using remainder_part from SR_next

            // Perform subtraction for the remainder in SR_next (top 9 bits) - divisor_abs
            // Note sub_borrow and sub_res depend on SR which is updated next cycle,
            // so for combinational we calculate on SR_next
            reg [9:0] sub_tmp;
            reg sub_borrow_tmp;

            sub_tmp = {1'b0, SR_next[16:8]} - {1'b0, divisor_abs};
            sub_borrow_tmp = sub_tmp[9];

            if (!sub_borrow_tmp) begin
                // remainder >= divisor, update remainder and set quotient bit to 1
                SR_next = {sub_tmp[8:0], SR_next[7:1], 1'b1};
            end else begin
                // remainder < divisor, quotient bit 0, remainder unchanged after shift
                SR_next = {SR_next[16:9], SR_next[7:0], 1'b0};
            end

            if (cnt_next == 4'd8) begin
                // Finished division
                working_next = 1'b0;
                res_valid_next = 1'b1;
            end
        end

        // When result is valid, prepare output applying sign correction
        if (!working && res_valid) begin
            quotient_unsigned = SR[7:0];
            remainder_unsigned = SR[16:9];

            // Apply sign correction
            if (sign && sign_quotient)
                quotient_unsigned = (~quotient_unsigned + 1'b1);
            if (sign && sign_remainder)
                remainder_unsigned = (~remainder_unsigned + 1'b1);

            SR_next = {remainder_unsigned, quotient_unsigned};
        end
    end

    // Update registers synchronously
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            SR <= 17'd0;
            cnt <= 4'd0;
            working <= 1'b0;
            res_valid <= 1'b0;
            result <= 16'd0;
            dividend_neg <= 1'b0;
            divisor_neg <= 1'b0;
            sign_quotient <= 1'b0;
            sign_remainder <= 1'b0;
            divisor_abs <= 8'd0;
            dividend_abs_ext <= 16'd0;
        end else begin
            // Clear res_valid if result is consumed
            if (res_valid && res_ready) begin
                res_valid <= 1'b0;
            end

            // Start division operation on opn_valid
            if (opn_valid && !working && !res_valid) begin
                if (sign) begin
                    dividend_neg <= dividend[7];
                    divisor_neg <= divisor[7];
                    divisor_abs <= divisor[7] ? (~divisor + 1'b1) : divisor;
                    dividend_abs_ext <= (dividend[7] ? (~dividend + 1'b1) : dividend) << 8;
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
                SR <= {dividend_abs_ext[15:7], 8'd0};
                cnt <= 4'd0;
                working <= 1'b1;
                res_valid <= 1'b0;
                result <= 16'd0;
            end else if (working) begin
                SR <= SR_next;
                cnt <= cnt_next;
                working <= working_next;
                res_valid <= res_valid_next;
            end else if (!working && res_valid) begin
                result <= SR_next[15:0];
            end
        end
    end

endmodule