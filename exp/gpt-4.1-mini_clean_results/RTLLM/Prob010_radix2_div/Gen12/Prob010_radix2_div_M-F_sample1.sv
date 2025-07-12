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

    // FSM states (classic Verilog style)
    localparam IDLE   = 2'd0;
    localparam DIVIDE = 2'd1;
    localparam DONE   = 2'd2;

    reg [1:0] state, next_state;

    // Shift register: 17-bit: [16:9] remainder, [8:1] quotient bits, [0] shifted in bit
    reg [16:0] SR;

    // Registers for absolute values and sign flags
    reg [7:0]  divisor_abs;
    reg [7:0]  dividend_abs;
    reg        dividend_neg;
    reg        divisor_neg;
    reg        quotient_neg;
    reg        remainder_neg;

    reg [3:0]  cnt;

    // Divisor extended and negated (17-bit)
    reg [16:0] divisor_ext;
    reg [16:0] neg_divisor;

    // For subtraction: remainder is 9 bits from SR[16:8]
    wire [8:0] remainder = SR[16:8];

    // Subtraction result (10-bit to detect borrow)
    wire [9:0] sub_res;

    // Signal to indicate subtraction success (no borrow)
    wire sub_success;

    // Next value of SR in division step
    reg [16:0] SR_next;

    // Intermediate wires for quotient and remainder raw values
    wire [7:0] raw_quotient = SR[8:1];
    wire [7:0] raw_remainder = SR[16:9];

    // Corrected quotient and remainder after sign fix
    reg [7:0] corrected_quotient;
    reg [7:0] corrected_remainder;

    // Reset and sequential logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state        <= IDLE;
            SR           <= 17'd0;
            divisor_abs  <= 8'd0;
            dividend_abs <= 8'd0;
            dividend_neg <= 1'b0;
            divisor_neg  <= 1'b0;
            quotient_neg <= 1'b0;
            remainder_neg<= 1'b0;
            cnt          <= 4'd0;
            res_valid    <= 1'b0;
            result       <= 16'd0;
            divisor_ext  <= 17'd0;
            neg_divisor  <= 17'd0;
        end else begin
            state <= next_state;
            case(state)
                IDLE: begin
                    res_valid <= 1'b0;
                    if(opn_valid) begin
                        // Compute absolute values and sign flags
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

                        quotient_neg  <= sign && (dividend[7] ^ divisor[7]);
                        remainder_neg <= sign && dividend[7];

                        // Initialize SR: remainder=0, quotient=dividend_abs shifted left 1 (to make room)
                        SR <= {9'd0, dividend_abs, 1'b0};

                        // Initialize extended divisor and its negation
                        divisor_ext <= {divisor_abs, 9'd0};
                        neg_divisor <= (~{divisor_abs, 9'd0}) + 17'd1;

                        cnt <= 4'd0;
                    end
                end

                DIVIDE: begin
                    cnt <= cnt + 1'b1;
                    SR <= SR_next;
                end

                DONE: begin
                    // Hold result until consumed
                    if(res_ready)
                        res_valid <= 1'b0;
                    else
                        res_valid <= 1'b1;
                end
            endcase
        end
    end

    // FSM next state logic
    always @(*) begin
        case(state)
            IDLE:   next_state = opn_valid ? DIVIDE : IDLE;
            DIVIDE: next_state = (cnt == 4'd8) ? DONE : DIVIDE;
            DONE:   next_state = (res_ready) ? (opn_valid ? DIVIDE : IDLE) : DONE;
            default: next_state = IDLE;
        endcase
    end

    // Compute subtraction remainder - divisor for one step:
    // remainder is 9-bit, need to align to upper bits of neg_divisor
    // Extract bits [16:8] from neg_divisor for subtraction
    wire [8:0] neg_divisor_hi = neg_divisor[16:8];

    assign sub_res = {1'b0, remainder} + {1'b0, neg_divisor_hi};
    assign sub_success = ~sub_res[9]; // no borrow if MSB = 0

    // Compute next SR value during DIVIDE
    always @(*) begin
        SR_next = SR << 1; // shift left by 1 by default

        if(state == DIVIDE) begin
            if(sub_success) begin
                // Update remainder bits with sub_res and set quotient bit = 1
                SR_next[16:8] = sub_res[8:0];
                SR_next[0] = 1'b1;
            end else begin
                // subtraction failed: remainder unchanged (shifted), quotient bit = 0 (default)
                // SR_next[16:8] unchanged from shift
            end
        end else begin
            SR_next = SR; // no change
        end
    end

    // Sign correction for quotient and remainder after division done
    always @(*) begin
        if(res_valid) begin
            // Quotient correction
            if(quotient_neg)
                // Use unsigned operations to avoid signed mismatch
                corrected_quotient = (~raw_quotient) + 8'd1;
            else
                corrected_quotient = raw_quotient;

            // Remainder correction
            if(remainder_neg)
                corrected_remainder = (~raw_remainder) + 8'd1;
            else
                corrected_remainder = raw_remainder;
        end else begin
            corrected_quotient = 8'd0;
            corrected_remainder = 8'd0;
        end
    end

    // Update result register in DONE state
    always @(posedge clk or posedge rst) begin
        if(rst)
            result <= 16'd0;
        else if(state == DONE)
            result <= {corrected_remainder, corrected_quotient};
    end

endmodule