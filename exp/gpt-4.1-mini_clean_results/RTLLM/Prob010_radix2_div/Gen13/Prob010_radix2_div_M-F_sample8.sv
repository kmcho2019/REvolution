module radix2_div (
    input           clk,
    input           rst,
    input           sign,
    input   [7:0]   dividend,
    input   [7:0]   divisor,
    input           opn_valid,
    input           res_ready,     // Handshake input for result consumption
    output reg      res_valid,
    output reg [15:0] result
);

    // FSM states
    localparam IDLE   = 2'd0;
    localparam DIVIDE = 2'd1;
    localparam DONE   = 2'd2;

    reg [1:0] state, next_state;

    // Shift register: 17-bit
    // Bits [16:8]: remainder (9 bits)
    // Bits [7:0]: quotient (8 bits)
    reg [16:0] SR;

    // Absolute values and sign flags
    reg [7:0] dividend_abs;
    reg [7:0] divisor_abs;
    reg       dividend_neg;
    reg       divisor_neg;
    reg       quotient_neg;
    reg       remainder_neg;

    // Counter from 1 to 8 for division steps
    reg [3:0] cnt;

    // Divisor extended and negated for subtraction (9 bits)
    reg [8:0] divisor_ext;
    reg [8:0] neg_divisor;

    // Wires for remainder and subtraction result
    wire [8:0] remainder = SR[16:8];
    wire [9:0] sub_res; // 10 bits for borrow detection
    wire       sub_success; // No borrow if 1

    reg [16:0] SR_next;

    // Raw quotient and remainder from SR after division
    wire [7:0] raw_quotient = SR[7:0];
    wire [7:0] raw_remainder = SR[16:9];

    // Corrected signed outputs
    reg [7:0] corrected_quotient;
    reg [7:0] corrected_remainder;

    // Reset and sequential logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state        <= IDLE;
            SR           <= 17'd0;
            dividend_abs <= 8'd0;
            divisor_abs  <= 8'd0;
            dividend_neg <= 1'b0;
            divisor_neg  <= 1'b0;
            quotient_neg <= 1'b0;
            remainder_neg<= 1'b0;
            cnt          <= 4'd0;
            res_valid    <= 1'b0;
            result       <= 16'd0;
            divisor_ext  <= 9'd0;
            neg_divisor  <= 9'd0;
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin
                    res_valid <= 1'b0;
                    cnt <= 4'd0;
                    if (opn_valid) begin
                        // Compute absolute values
                        if (sign && dividend[7]) begin
                            dividend_abs <= (~dividend) + 8'd1;
                            dividend_neg <= 1'b1;
                        end else begin
                            dividend_abs <= dividend;
                            dividend_neg <= 1'b0;
                        end

                        if (sign && divisor[7]) begin
                            divisor_abs <= (~divisor) + 8'd1;
                            divisor_neg <= 1'b1;
                        end else begin
                            divisor_abs <= divisor;
                            divisor_neg <= 1'b0;
                        end

                        quotient_neg  <= sign && (dividend[7] ^ divisor[7]);
                        remainder_neg <= sign && dividend[7];

                        // Initialize SR:
                        // remainder (9 bits) = 0
                        // quotient (8 bits) = dividend_abs shifted left by 1 (9 bits total)
                        // So SR = {9'd0, dividend_abs << 1} fits into 17 bits
                        SR <= {9'd0, dividend_abs << 1};

                        // Divisor extended and negated (9 bits) for subtraction with remainder
                        divisor_ext <= {divisor_abs, 1'b0};         // divisor_abs shifted left 1 bit (9 bits)
                        neg_divisor <= (~{divisor_abs, 1'b0}) + 9'd1; // two's complement negation

                        cnt <= 4'd1; // start from 1, step 1 to 8
                    end
                end

                DIVIDE: begin
                    cnt <= cnt + 1'b1;
                    SR <= SR_next;
                end

                DONE: begin
                    // Keep res_valid until result consumed
                    if (res_ready)
                        res_valid <= 1'b0;
                    else
                        res_valid <= 1'b1;
                end

                default: begin
                    // Defensive fallback
                    cnt <= 4'd0;
                    res_valid <= 1'b0;
                    SR <= 17'd0;
                end
            endcase
        end
    end

    // FSM next state logic
    always @(*) begin
        case(state)
            IDLE:   next_state = (opn_valid) ? DIVIDE : IDLE;
            DIVIDE: next_state = (cnt == 4'd8) ? DONE : DIVIDE;
            DONE:   next_state = (res_ready) ? (opn_valid ? DIVIDE : IDLE) : DONE;
            default: next_state = IDLE;
        endcase
    end

    // Subtraction: remainder - divisor_ext = remainder + neg_divisor
    assign sub_res = {1'b0, remainder} + {1'b0, neg_divisor};
    assign sub_success = ~sub_res[9]; // no borrow if MSB=0

    // Next SR update during DIVIDE state
    always @(*) begin
        SR_next = SR << 1; // default shift left by 1

        if (state == DIVIDE) begin
            if (sub_success) begin
                // Update remainder bits with sub_res result and set quotient LSB = 1
                SR_next[16:8] = sub_res[8:0];
                SR_next[0] = 1'b1;
            end else begin
                // Subtraction failed: remainder unchanged except shift, quotient bit=0 by default
                // No changes to remainder bits beyond the shift left
            end
        end else begin
            SR_next = SR; // no change outside DIVIDE
        end
    end

    // Sign correction for quotient and remainder after division done
    always @(*) begin
        if (state == DONE) begin
            // Quotient sign correction
            if (quotient_neg)
                corrected_quotient = (~raw_quotient) + 8'd1;
            else
                corrected_quotient = raw_quotient;

            // Remainder sign correction
            if (remainder_neg)
                corrected_remainder = (~raw_remainder) + 8'd1;
            else
                corrected_remainder = raw_remainder;
        end else begin
            corrected_quotient = 8'd0;
            corrected_remainder = 8'd0;
        end
    end

    // Store result in DONE state
    always @(posedge clk or posedge rst) begin
        if (rst)
            result <= 16'd0;
        else if (state == DONE)
            result <= {corrected_remainder, corrected_quotient};
    end

    // Assert res_valid in DONE state
    always @(posedge clk or posedge rst) begin
        if (rst)
            res_valid <= 1'b0;
        else if (state == DONE)
            res_valid <= 1'b1;
        else if (res_ready)
            res_valid <= 1'b0;
    end

endmodule