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

    reg [16:0] SR;         // Shift register: [16:8] remainder, [7:0] quotient bits + extra bit
    reg [7:0]  divisor_abs;
    reg [16:0] neg_divisor_ext; // NEG_DIVISOR shifted to align with remainder bits
    reg [3:0]  cnt;
    reg        busy;

    reg        dividend_neg, divisor_neg;
    reg        quotient_neg, remainder_neg;

    // Capture inputs and signs
    wire [7:0] dividend_abs = (sign && dividend[7]) ? (~dividend + 8'd1) : dividend;
    wire [7:0] divisor_abs_raw = (sign && divisor[7]) ? (~divisor + 8'd1) : divisor;

    // Prepare NEG_DIVISOR (two's complement divisor_abs) aligned at bits [16:8]
    wire [16:0] divisor_ext = {divisor_abs, 9'd0}; // divisor_abs at bits [16:9], zeros below
    wire [16:0] neg_divisor_ext_wire = (~divisor_ext) + 17'd1;

    // FSM states simplified: busy flag for division in progress
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            SR          <= 17'd0;
            divisor_abs <= 8'd0;
            neg_divisor_ext <= 17'd0;
            cnt         <= 4'd0;
            busy        <= 1'b0;
            res_valid   <= 1'b0;
            result      <= 16'd0;
            dividend_neg <= 1'b0;
            divisor_neg  <= 1'b0;
            quotient_neg <= 1'b0;
            remainder_neg<= 1'b0;
        end else begin
            if (!busy) begin
                res_valid <= res_valid && (~res_valid || 1'b0); // hold or clear by external if needed

                if (opn_valid && !res_valid) begin
                    // Start new operation
                    dividend_neg <= (sign) ? dividend[7] : 1'b0;
                    divisor_neg  <= (sign) ? divisor[7] : 1'b0;
                    quotient_neg <= (sign) ? (dividend[7] ^ divisor[7]) : 1'b0;
                    remainder_neg<= (sign) ? dividend[7] : 1'b0;

                    divisor_abs <= divisor_abs_raw;
                    neg_divisor_ext <= neg_divisor_ext_wire;

                    // Initialize SR: remainder=0(8 bits), quotient = dividend_abs shifted left by 1 bit
                    SR <= {9'd0, dividend_abs, 1'b0};

                    cnt <= 4'd1;
                    busy <= 1'b1;
                    res_valid <= 1'b0;
                end
            end else begin
                // Division process
                // Shift SR left by 1
                SR <= SR << 1;

                // Compute SR[16:8] + NEG_DIVISOR
                // Extract remainder field from shifted SR for addition
                // We need to do addition on bits [16:8], so add NEG_DIVISOR
                // SR_next = {remainder_new, quotient_new} after decision

                // Calculate sum for subtraction (remainder + neg_divisor)
                // Wait for combinational sum and decision in next clock
                // So implement with pipeline style:

                // Prepare sum:
                // sum = SR[16:8] + NEG_DIVISOR[16:8] (NEG_DIVISOR aligned)
                // Actually NEG_DIVISOR is aligned for direct addition with SR[16:8]

                // To implement in synchronous always block, calculate sum combinationally first,
                // then update SR and quotient bit according to MSB of sum.

                // Using a temporary variable to hold sum
                reg [16:0] sum;
                sum = SR[16:8] + neg_divisor_ext[16:8]; // add just upper 9 bits aligned

                // sum is signed subtraction of divisor_abs from remainder

                // Decision:
                if (!sum[8]) begin
                    // No borrow (MSB bit 8 of sum == 0), subtraction successful
                    // Update remainder field SR[16:8]
                    SR[16:8] <= sum[8:0]; // keep lower 9 bits
                    SR[0] <= 1'b1;        // set quotient bit to 1 (LSB after shift)
                end else begin
                    // Borrow happened, restore remainder, quotient bit = 0 (already 0 after shift)
                    // No update needed for SR[16:8], quotient bit SR[0] remains 0
                end

                if (cnt == 8) begin
                    busy <= 1'b0;
                    res_valid <= 1'b1;

                    // After last iteration, SR[16:8] contains remainder, SR[7:0] quotient

                    // Apply sign corrections
                    reg [7:0] final_quotient;
                    reg [7:0] final_remainder;

                    // Quotient sign correction
                    if (quotient_neg)
                        final_quotient = (~SR[7:0]) + 8'd1;
                    else
                        final_quotient = SR[7:0];

                    // Remainder sign correction
                    if (remainder_neg)
                        final_remainder = (~SR[16:9]) + 8'd1;
                    else
                        final_remainder = SR[16:9];

                    result <= {final_remainder, final_quotient};
                end else begin
                    cnt <= cnt + 1'b1;
                end
            end

            if (res_valid && !opn_valid) begin
                // allow external to clear res_valid by new opn_valid
                // or by reset
                res_valid <= res_valid; 
            end
        end
    end

endmodule