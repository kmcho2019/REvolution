module radix2_div (
    input             clk,
    input             rst,
    input             sign,           // 1 = signed division, 0 = unsigned
    input      [7:0]  dividend,
    input      [7:0]  divisor,
    input             opn_valid,
    output reg        res_valid,
    output reg [15:0] result          // {remainder[7:0], quotient[7:0]}
);

    // One-hot encoded states for clarity
    localparam S_IDLE   = 3'b001;
    localparam S_CALC   = 3'b010;
    localparam S_DONE   = 3'b100;

    reg [2:0] state, next_state;

    // Latched inputs and sign info
    reg [7:0] dividend_r, divisor_r;
    reg       dividend_neg, divisor_neg;
    reg [7:0] dividend_abs, divisor_abs;

    // 17-bit shift register for remainder (upper 9 bits) and quotient (lower 8 bits)
    reg [16:0] SR, SR_next;

    // Iteration counter (0..8)
    reg [3:0] cnt, cnt_next;

    // Wires for subtract operation
    wire [8:0] rem_part  = SR[16:8];             // upper 9 bits remainder
    wire [8:0] sub_res   = rem_part - {1'b0, divisor_abs};
    wire       borrow    = sub_res[8];           // MSB indicates borrow (1 = negative)

    // Mux for next remainder: if borrow, keep remainder, else sub_res (non-restoring division)
    wire [8:0] next_rem  = borrow ? rem_part : sub_res;

    // Next quotient bit: 1 if no borrow, else 0
    wire       qbit      = borrow ? 1'b0 : 1'b1;

    // State register and control signals
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state        <= S_IDLE;
            SR           <= 17'd0;
            cnt          <= 4'd0;
            res_valid    <= 1'b0;
            result       <= 16'd0;
            dividend_r   <= 8'd0;
            divisor_r    <= 8'd0;
            dividend_neg <= 1'b0;
            divisor_neg  <= 1'b0;
            dividend_abs <= 8'd0;
            divisor_abs  <= 8'd0;
        end else begin
            state <= next_state;

            case(state)
                S_IDLE: begin
                    res_valid <= 1'b0;
                    cnt       <= 4'd0;

                    if (opn_valid && divisor != 8'd0) begin
                        // Latch inputs
                        dividend_r   <= dividend;
                        divisor_r    <= divisor;

                        if (sign) begin
                            dividend_neg <= dividend[7];
                            divisor_neg  <= divisor[7];
                            dividend_abs <= dividend[7] ? (~dividend + 8'd1) : dividend;
                            divisor_abs  <= divisor[7] ? (~divisor + 8'd1) : divisor;
                        end else begin
                            dividend_neg <= 1'b0;
                            divisor_neg  <= 1'b0;
                            dividend_abs <= dividend;
                            divisor_abs  <= divisor;
                        end

                        // Initialize SR: remainder=0, quotient=dividend_abs
                        // This sets remainder in upper 9 bits to 0, quotient in lower 8 bits to dividend_abs
                        SR <= {9'd0, dividend_abs};
                    end
                end

                S_CALC: begin
                    // Update counter
                    cnt <= cnt + 1'b1;

                    // Update SR with shifted in quotient bit and updated remainder
                    SR <= SR_next;
                end

                S_DONE: begin
                    res_valid <= 1'b1;

                    // At DONE state, apply sign correction and output result
                    // Extract raw quotient and remainder
                    // Quotient in SR[7:0], remainder in SR[16:9] (8 bits)
                    reg [7:0] raw_quotient;
                    reg [7:0] raw_remainder;
                    reg [7:0] corr_quotient;
                    reg [7:0] corr_remainder;

                    raw_quotient  = SR[7:0];
                    raw_remainder = SR[16:9];

                    if (sign) begin
                        // Quotient sign = dividend_neg xor divisor_neg
                        corr_quotient = (dividend_neg ^ divisor_neg) ? (~raw_quotient + 8'd1) : raw_quotient;
                        // Remainder sign = dividend_neg
                        corr_remainder = dividend_neg ? (~raw_remainder + 8'd1) : raw_remainder;
                    end else begin
                        corr_quotient = raw_quotient;
                        corr_remainder = raw_remainder;
                    end

                    result <= {corr_remainder, corr_quotient};
                end
            endcase
        end
    end

    // Compute SR_next combinationally during CALC state
    always @(*) begin
        // Default next state and signals
        next_state = state;
        cnt_next   = cnt;
        SR_next    = SR;

        case(state)
            S_IDLE: begin
                if (opn_valid && divisor != 8'd0) begin
                    next_state = S_CALC;
                end
            end

            S_CALC: begin
                // Prepare next SR with shifted remainder and quotient bit inserted

                // Shift left SR by 1 bit: {SR[15:0], 1'b0}
                // Then override upper 9 bits remainder with next_rem and insert qbit in LSB of quotient
                // New SR = {next_rem[8:0], SR[7:1], qbit}
                SR_next = {next_rem, SR[7:1], qbit};

                if (cnt == 4'd8) begin
                    next_state = S_DONE;
                end
            end

            S_DONE: begin
                if (opn_valid) begin
                    next_state = S_CALC;

                    // Latch new inputs handled in sequential block, so just move on
                end else begin
                    next_state = S_DONE;
                end
            end
        endcase
    end

endmodule