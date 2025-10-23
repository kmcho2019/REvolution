module radix2_div (
    input             clk,
    input             rst,
    input             sign,          // 1: signed division, 0: unsigned
    input      [7:0]  dividend,
    input      [7:0]  divisor,
    input             opn_valid,
    output reg        res_valid,
    output reg [15:0] result          // {remainder[7:0], quotient[7:0]}
);

    localparam IDLE    = 2'd0;
    localparam RUNNING = 2'd1;
    localparam DONE    = 2'd2;

    reg [1:0] state, next_state;

    // Internal registers for sign handling
    reg dividend_neg, divisor_neg;

    // Absolute values of dividend and divisor
    reg [7:0] abs_dividend;
    reg [7:0] abs_divisor;

    // The shift register: 17 bits = 9 bits remainder + 8 bits quotient
    reg [16:0] SR;

    // Counter for division steps (1 to 8)
    reg [3:0] cnt;

    // Wires for subtraction
    wire [8:0] remainder_part;
    wire [8:0] sub_res;
    wire       borrow;

    // Extract upper 9 bits (remainder) from SR
    assign remainder_part = SR[16:8];

    // Subtract abs_divisor from remainder_part
    assign {borrow, sub_res} = {1'b0, remainder_part} - {1'b0, abs_divisor};

    // Next value of shift register depending on borrow
    wire [16:0] SR_next = {sub_res[7:0], SR[7:0], ~borrow}; 
    // Explanation: 
    // - sub_res[7:0]: new remainder (lowest 8 bits of subtraction)
    // - SR[7:0]: current quotient shifted left by 1 bit implicitly when combined
    // Actually we must shift left: first shift remainder and quotient left 1, then add quotient bit.
    // We'll fix this in code below.

    // For clarity and correctness, we implement shift and update inside the always block.

    // Registers to hold final signed outputs before assigning result
    reg [7:0] final_quotient;
    reg [7:0] final_remainder;

    // Sequential logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state         <= IDLE;
            res_valid     <= 1'b0;
            result        <= 16'b0;
            cnt           <= 4'd0;
            SR            <= 17'd0;
            abs_dividend  <= 8'd0;
            abs_divisor   <= 8'd0;
            dividend_neg  <= 1'b0;
            divisor_neg   <= 1'b0;
            final_quotient  <= 8'd0;
            final_remainder <= 8'd0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    res_valid <= 1'b0;
                    if (opn_valid) begin
                        // Save signs and compute absolute values
                        dividend_neg <= sign & dividend[7];
                        divisor_neg  <= sign & divisor[7];

                        abs_dividend <= sign && dividend[7] ? (~dividend + 1'b1) : dividend;
                        abs_divisor  <= sign && divisor[7]  ? (~divisor + 1'b1)  : divisor;

                        // Initialize shift register: remainder=0, quotient=abs_dividend shifted left 0 bits
                        // We load dividend into the quotient bits of SR; remainder part = 0
                        SR <= {9'd0, abs_dividend};

                        cnt <= 4'd0;
                    end
                end

                RUNNING: begin
                    // Perform one division step:
                    // Subtract divisor from remainder part
                    // If no borrow, new remainder is sub_res and quotient bit = 1
                    // Else remainder unchanged and quotient bit = 0
                    // Shift SR left by 1, and input quotient bit at LSB

                    if (cnt < 4'd8) begin
                        if (~borrow) begin
                            // subtraction succeeded
                            // Shift left remainder and quotient by 1, insert 1 at LSB of quotient
                            SR <= {sub_res[7:0], SR[7:0], 1'b1};
                        end else begin
                            // subtraction failed, keep remainder, shift left quotient with 0
                            SR <= {remainder_part[7:0], SR[7:0], 1'b0};
                        end
                        cnt <= cnt + 1'b1;
                    end
                end

                DONE: begin
                    res_valid <= 1'b1;

                    // Compute final signed quotient and remainder once here (combinationally assigned below)
                    // Hold final values in registers for output stability
                    final_quotient  <= result[7:0];   // placeholder, will be assigned combinationally below
                    final_remainder <= result[15:8];  // placeholder, will be assigned combinationally below
                end

                default: ;
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: if (opn_valid) next_state = RUNNING;
            RUNNING: if (cnt == 4'd8) next_state = DONE;
            DONE: if (!res_valid) next_state = IDLE; else if (opn_valid) next_state = RUNNING;
            default: next_state = IDLE;
        endcase
    end

    // Combinational block to assign final signed quotient and remainder after division completes
    always @(*) begin
        if (state == DONE) begin
            // Extract quotient and remainder from SR
            // remainder = upper 9 bits of SR (but only 8 bits valid)
            // quotient = lower 8 bits of SR

            // remainder in SR is 9 bits, bit 8 is extra bit for calculations and should be discarded (like problem statement)
            // Use bits [16:8] for remainder, take bits [16:9] as remainder[7:0]
            // But we shifted in a quotient bit at LSB each cycle, so remainder is bits [16:8] (9 bits)
            // We take remainder as bits [16:9] => remainder_part[8:1]

            // Let's define:
            // remainder_raw = SR[16:9]
            // quotient_raw = SR[7:0]

            reg [7:0] remainder_raw;
            reg [7:0] quotient_raw;
            reg       quotient_sign;
            reg       remainder_sign;

            remainder_raw = SR[16:9];
            quotient_raw  = SR[7:0];

            quotient_sign = sign & (dividend_neg ^ divisor_neg);
            remainder_sign = sign & dividend_neg;

            // Convert quotient back to signed if needed
            if (quotient_sign)
                final_quotient = (~quotient_raw) + 1'b1;
            else
                final_quotient = quotient_raw;

            // Convert remainder back to signed if needed
            if (remainder_sign)
                final_remainder = (~remainder_raw) + 1'b1;
            else
                final_remainder = remainder_raw;

            // Assign to output result
            result = {final_remainder, final_quotient};
        end else begin
            result = 16'd0;
            final_quotient = 8'd0;
            final_remainder = 8'd0;
        end
    end

endmodule