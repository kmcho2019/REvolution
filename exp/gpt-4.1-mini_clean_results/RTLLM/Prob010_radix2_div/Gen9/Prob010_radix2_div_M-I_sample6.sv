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

    // States
    localparam IDLE   = 1'b0;
    localparam DIVIDE = 1'b1;
    reg state;

    // Internal registers
    reg [16:0] SR;                // Shift register: [16:9] remainder (8 bits + 1 bit extra), [8:1] quotient bits, SR[0] extra bit
    reg [7:0]  divisor_abs;       // absolute value of divisor
    reg [16:0] neg_divisor_ext;   // negated divisor extended (shifted to bits 16:9)
    reg [3:0]  cnt;

    // Sign flags
    reg        dividend_neg;
    reg        divisor_neg;
    reg        quotient_neg;
    reg        remainder_neg;

    // Combinational sum for subtraction
    wire [8:0] remainder_part = SR[16:8];              // 9 bits remainder (includes 1 extra bit for borrow detection)
    wire [8:0] neg_divisor_part = neg_divisor_ext[16:8];// aligned neg_divisor for subtraction

    wire [9:0] sum_ext = {1'b0, remainder_part} + {1'b0, neg_divisor_part}; // 10 bits to detect borrow

    // Calculate absolute values of inputs (combinational)
    wire [7:0] dividend_abs = (sign && dividend[7]) ? (~dividend + 8'd1) : dividend;
    wire [7:0] divisor_abs_raw = (sign && divisor[7]) ? (~divisor + 8'd1) : divisor;

    // Prepare neg_divisor_ext combinationally (to be latched on start)
    wire [16:0] divisor_ext_wire = {divisor_abs_raw, 9'd0}; // divisor_abs_raw at bits [16:9]
    wire [16:0] neg_divisor_ext_wire = (~divisor_ext_wire) + 17'd1;

    // Sequential logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            SR <= 17'd0;
            divisor_abs <= 8'd0;
            neg_divisor_ext <= 17'd0;
            cnt <= 4'd0;
            res_valid <= 1'b0;
            result <= 16'd0;
            dividend_neg <= 1'b0;
            divisor_neg <= 1'b0;
            quotient_neg <= 1'b0;
            remainder_neg <= 1'b0;
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    res_valid <= 1'b0;
                    if (opn_valid) begin
                        // Capture signs
                        dividend_neg <= (sign) ? dividend[7] : 1'b0;
                        divisor_neg <= (sign) ? divisor[7] : 1'b0;
                        quotient_neg <= (sign) ? (dividend[7] ^ divisor[7]) : 1'b0;
                        remainder_neg <= (sign) ? dividend[7] : 1'b0;

                        divisor_abs <= divisor_abs_raw;
                        neg_divisor_ext <= neg_divisor_ext_wire;

                        // Initialize shift register SR:
                        // remainder part = 0 (9 bits), quotient part = dividend_abs shifted left by 1 (8 bits + 1)
                        SR <= {9'd0, dividend_abs, 1'b0};

                        cnt <= 4'd0;
                        state <= DIVIDE;
                    end
                end

                DIVIDE: begin
                    // Shift left SR by 1
                    // The bit SR[0] will be filled with quotient bit based on subtraction result
                    // First shift SR left by 1
                    SR <= {SR[15:0], 1'b0};

                    // cnt incremented here to count iteration number
                    cnt <= cnt + 1'b1;

                    // After shift, perform subtraction decision
                    // We cannot do combinational assignment in always block
                    // So we use an extra register for SR and update it properly in the next clock cycle

                    // However, we can update SR[16:8] and SR[0] accordingly after this block using an intermediate register,
                    // or update in the next cycle. For simplicity, we implement the subtraction logic combinationally outside and 
                    // use a pipeline approach.

                    // To implement subtraction and quotient bit update sequentially:
                    // Use a pipeline: save subtraction decision result in combinational and update SR accordingly on next clock

                    // We implement the subtraction decision combinationally in the same cycle to update SR accordingly

                    // So, do not assign SR here again; instead, use a separate combinational block below.

                    if (cnt == 8) begin
                        state <= IDLE;
                        res_valid <= 1'b1;
                    end
                end

                default: state <= IDLE;
            endcase
        end
    end

    // Subtraction decision and SR update combinationally in DIVIDE state
    // This block controls the update of SR[16:8] remainder and SR[0] quotient bit after shifting
    // It must be sensitive to SR and neg_divisor_ext

    reg [16:0] SR_next;

    always @(*) begin
        SR_next = SR;
        if (state == DIVIDE) begin
            // After left shift in sequential always block, we perform subtraction decision here:
            // sum_ext = remainder + neg_divisor_ext;
            // If MSB of sum_ext[9] == 0 => no borrow, subtraction successful
            // update remainder part with sum_ext[8:0] and set quotient bit (LSB SR[0]) to 1
            // else remainder unchanged, quotient bit remains 0

            if (!sum_ext[9]) begin
                // subtraction succeeded
                SR_next[16:8] = sum_ext[8:0];
                SR_next[0] = 1'b1;
            end else begin
                // subtraction failed
                // remainder unchanged, quotient bit = 0 (already 0 after shift)
                // no change needed
            end
        end
    end

    // Register SR updated with SR_next on the positive clock edge except during IDLE (already handled)
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Already handled above
        end else if (state == DIVIDE) begin
            SR <= SR_next;
        end
    end

    // Result output logic after division completes
    // Apply sign correction for quotient and remainder

    // Registers to hold final quotient and remainder after sign correction
    reg [7:0] final_quotient;
    reg [7:0] final_remainder;

    always @(*) begin
        // Extract quotient from SR bits [8:1]
        // Extract remainder from SR bits [16:9]
        if (res_valid) begin
            // Quotient sign correction
            if (quotient_neg)
                final_quotient = (~SR[8:1]) + 8'd1;
            else
                final_quotient = SR[8:1];

            // Remainder sign correction
            if (remainder_neg)
                final_remainder = (~SR[16:9]) + 8'd1;
            else
                final_remainder = SR[16:9];
        end else begin
            final_quotient = 8'd0;
            final_remainder = 8'd0;
        end
    end

    // Output result register update
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            result <= 16'd0;
        end else if (res_valid) begin
            result <= {final_remainder, final_quotient};
        end
    end

endmodule