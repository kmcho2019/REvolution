module radix2_div (
    input          clk,
    input          rst,
    input          sign,
    input  [7:0]   dividend,
    input  [7:0]   divisor,
    input          opn_valid,
    output reg     res_valid,
    output reg [15:0] result
);
    // Internal states
    reg busy; // operation in progress

    // Registers for sign and absolute values
    reg dividend_neg;
    reg divisor_neg;
    reg sign_quotient;
    reg sign_remainder;

    reg [7:0] dividend_abs;
    reg [7:0] divisor_abs;

    // 17-bit remainder register: upper 9 bits for remainder, lower bits for shifting in
    // Initialized with {8'b0, dividend_abs}
    reg [16:0] remainder_reg;

    // 8-bit quotient register
    reg [7:0] quotient_reg;

    // Counter for iteration (0 to 7)
    reg [3:0] count;

    // Subtraction result for checking remainder - divisor_abs
    reg [8:0] sub_res;

    // Flag to indicate the subtraction result >=0
    wire sub_non_negative;

    assign sub_non_negative = ~sub_res[8]; // MSB=0 means non-negative

    // Calculate absolute values and signs at start
    wire [7:0] dividend_abs_w = sign && dividend[7] ? (~dividend + 1) : dividend;
    wire [7:0] divisor_abs_w  = sign && divisor[7]  ? (~divisor + 1)  : divisor;
    wire dividend_neg_w = sign ? dividend[7] : 1'b0;
    wire divisor_neg_w  = sign ? divisor[7]  : 1'b0;

    // Temporary registers for final sign-corrected quotient and remainder
    reg [7:0] final_quotient;
    reg [7:0] final_remainder;

    integer i; // for possible debug or extension (not used)

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            busy <= 1'b0;
            res_valid <= 1'b0;
            result <= 16'b0;
            dividend_neg <= 1'b0;
            divisor_neg <= 1'b0;
            sign_quotient <= 1'b0;
            sign_remainder <= 1'b0;
            dividend_abs <= 8'b0;
            divisor_abs <= 8'b0;
            remainder_reg <= 17'b0;
            quotient_reg <= 8'b0;
            count <= 4'd0;
            sub_res <= 9'd0;
            final_quotient <= 8'd0;
            final_remainder <= 8'd0;
        end else begin
            if (!busy && opn_valid) begin
                // Start operation: latch values
                dividend_abs <= dividend_abs_w;
                divisor_abs <= divisor_abs_w;
                dividend_neg <= dividend_neg_w;
                divisor_neg <= divisor_neg_w;
                sign_quotient <= dividend_neg_w ^ divisor_neg_w;
                sign_remainder <= dividend_neg_w;
                remainder_reg <= {9'd0, dividend_abs_w}; // remainder upper 9 bits cleared, lower 8 bits dividend
                quotient_reg <= 8'd0;
                count <= 4'd0;
                busy <= 1'b1;
                res_valid <= 1'b0;
                final_quotient <= 8'd0;
                final_remainder <= 8'd0;
            end else if (busy) begin
                // Perform division step

                // Shift remainder left by 1
                // Make temporary shifted remainder
                reg [16:0] shifted;
                shifted = remainder_reg << 1;

                // Perform subtraction: upper 9 bits of shifted - divisor_abs
                // upper 9 bits: shifted[16:8], divisor_abs is 8 bits, extend divisor_abs to 9 bits
                sub_res = {1'b0, shifted[16:8]} - {1'b0, divisor_abs};

                if (sub_non_negative) begin
                    // subtraction positive or zero: update remainder upper bits with subtraction result
                    remainder_reg <= {sub_res[8:0], shifted[7:0]};
                    quotient_reg <= {quotient_reg[6:0], 1'b1};
                end else begin
                    // subtraction negative: restore remainder upper bits, just shifted
                    remainder_reg <= shifted;
                    quotient_reg <= {quotient_reg[6:0], 1'b0};
                end

                count <= count + 4'd1;

                if (count == 4'd7) begin
                    // Last iteration done (counts 0 to 7 for 8 steps)
                    busy <= 1'b0;
                    res_valid <= 1'b1;

                    // Extract 8-bit remainder from remainder_reg[16:9]
                    final_remainder <= remainder_reg[16:9];

                    // Sign correction for quotient
                    if (sign && sign_quotient) begin
                        final_quotient <= (~quotient_reg + 1);
                    end else begin
                        final_quotient <= quotient_reg;
                    end

                    // Sign correction for remainder
                    if (sign && sign_remainder) begin
                        final_remainder <= (~final_remainder + 1);
                    end
                end
            end else begin
                // Idle state, clear res_valid if opn_valid asserted again
                if (res_valid && opn_valid) begin
                    res_valid <= 1'b0;
                    result <= 16'b0;
                end
            end
        end
    end

    // Assign the output result combinationally when res_valid asserted
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            result <= 16'b0;
        end else if (res_valid) begin
            // When result ready, pack remainder in upper 8 bits, quotient in lower 8 bits
            result <= {final_remainder, final_quotient};
        end
    end
endmodule