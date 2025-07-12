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

    // FSM states
    localparam IDLE   = 2'd0;
    localparam DIVIDE = 2'd1;
    localparam DONE   = 2'd2;

    reg [1:0] state, next_state;

    // Internal registers for sign and absolute values
    reg dividend_neg, divisor_neg;
    reg [7:0] dividend_abs, divisor_abs;
    reg quotient_neg, remainder_neg;

    // Shift register: {remainder[8:0], quotient[7:0]} = 17 bits total
    // During process: remainder in upper 9 bits, quotient in lower 8 bits
    reg [16:0] SR;
    reg [3:0] cnt; // 4-bit counter for 8 steps

    // Prepare divisor for subtraction (extended to 9 bits to match remainder width)
    reg [8:0] divisor_ext;
    wire [9:0] sub_res; // 10 bits to capture borrow bit

    // Signals for subtraction
    wire borrow;

    // Subtraction combinational: remainder - divisor_ext
    assign sub_res = {1'b0, SR[16:8]} - {1'b0, divisor_ext};
    assign borrow = sub_res[9]; // borrow if MSB = 1

    // Next state logic
    always @(*) begin
        case(state)
            IDLE: next_state = (opn_valid) ? DIVIDE : IDLE;
            DIVIDE: next_state = (cnt == 4'd8) ? DONE : DIVIDE;
            DONE: next_state = (opn_valid) ? DIVIDE : DONE;
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            state <= IDLE;
            res_valid <= 1'b0;
            result <= 16'd0;
            SR <= 17'd0;
            cnt <= 4'd0;
            dividend_abs <= 8'd0;
            divisor_abs <= 8'd0;
            dividend_neg <= 1'b0;
            divisor_neg <= 1'b0;
            quotient_neg <= 1'b0;
            remainder_neg <= 1'b0;
            divisor_ext <= 9'd0;
        end else begin
            state <= next_state;
            case(state)
                IDLE: begin
                    res_valid <= 1'b0;
                    if(opn_valid) begin
                        // Capture signs and absolute values for signed operation
                        if(sign && dividend[7]) begin
                            dividend_abs <= (~dividend) + 8'd1;
                            dividend_neg <= 1'b1;
                        end else begin
                            dividend_abs <= dividend;
                            dividend_neg <= 1'b0;
                        end
                        if(sign && divisor[7]) begin
                            divisor_abs <= (~divisor) + 8'd1;
                            divisor_neg <= 1'b1;
                        end else begin
                            divisor_abs <= divisor;
                            divisor_neg <= 1'b0;
                        end

                        quotient_neg <= (sign && (dividend[7] ^ divisor[7]));
                        remainder_neg <= (sign && dividend[7]);

                        // Initialize shift register: remainder=0 (9 bits), quotient=dividend_abs (8 bits)
                        // Because division logic shifts quotient bits into lower 8 bits of SR,
                        // we align dividend_abs in lower 8 bits, remainder cleared.
                        SR <= {9'd0, dividend_abs};

                        cnt <= 4'd0;
                        divisor_ext <= {1'b0, divisor_abs}; // extend divisor to 9 bits for subtraction
                    end
                end
                DIVIDE: begin
                    cnt <= cnt + 1'b1;
                    // Shift left SR by 1
                    // Attempt subtract divisor_ext from remainder shifted in SR[16:8] after shift
                    // First shift left
                    // SR shift left by 1 bit:
                    // The current SR is: {R[8:0], Q[7:0]}
                    // After shift left 1 bit: R_new = (R << 1) | Q[7]
                    // Q_new = Q << 1, last bit is set depending on subtraction success.

                    // We do all in one step:
                    // Shift left SR by 1
                    // Then attempt subtraction:
                    // If no borrow, update remainder with subtraction result and set quotient bit to 1
                    // Else restore remainder and set quotient bit to 0.

                    // Implemented below by separate assignments:
                    // 1. Shift left once: shift SR by 1, MSB will be shifted out (ignored)
                    // 2. Subtract divisor from new remainder

                    reg [16:0] SR_shift;
                    reg [8:0] rem_shift;
                    reg [8:0] rem_sub;

                    // Shift left
                    SR_shift = SR << 1;
                    rem_shift = SR_shift[16:8];

                    // Attempt subtract divisor
                    rem_sub = rem_shift - divisor_ext;

                    if (rem_sub[8] == 1'b0) begin
                        // No borrow: subtraction success
                        // Update remainder in SR to rem_sub
                        // Set quotient LSB to 1
                        SR <= {rem_sub, SR_shift[7:1], 1'b1};
                    end else begin
                        // Borrow: subtraction failed
                        // Keep remainder as rem_shift (restored), quotient bit 0
                        SR <= {rem_shift, SR_shift[7:1], 1'b0};
                    end
                end
                DONE: begin
                    res_valid <= 1'b1;
                    // Compute final corrected quotient and remainder with sign correction
                    // Done in combinational block below, assigned to result here.
                    // Keep result stable until next opn_valid
                end
            endcase
        end
    end

    // Final output result generation with sign correction
    // Extract raw quotient and remainder
    wire [7:0] raw_quotient = SR[7:0];
    wire [8:0] raw_remainder = SR[16:8]; // 9 bits remainder

    // Because remainder is max 8 bits (the original 8-bit dividend), 
    // The 9th bit can be at most 1 from shifting.
    // We need to saturate or truncate remainder to 8 bits properly.

    // Compute signed remainder correction in combinational
    reg [7:0] corrected_quotient;
    reg [7:0] corrected_remainder;

    always @(*) begin
        // Quotient sign correction
        if (res_valid) begin
            if (quotient_neg)
                corrected_quotient = (~raw_quotient) + 8'd1;
            else
                corrected_quotient = raw_quotient;

            // Remainder sign correction
            // The remainder is 9 bits unsigned, but original remainder is 8 bits signed
            // We discard the MSB (bit 8) since remainder must be less than divisor
            // Take lower 8 bits as raw remainder for correction
            if (remainder_neg) begin
                corrected_remainder = (~raw_remainder[7:0]) + 8'd1;
            end else begin
                corrected_remainder = raw_remainder[7:0];
            end
        end else begin
            corrected_quotient = 8'd0;
            corrected_remainder = 8'd0;
        end
    end

    // Assign corrected result at DONE state
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            result <= 16'd0;
        end else if(state == DONE) begin
            result <= {corrected_remainder, corrected_quotient};
        end
    end

endmodule