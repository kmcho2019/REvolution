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
    typedef enum logic [1:0] {
        IDLE   = 2'd0,
        DIVIDE = 2'd1,
        DONE   = 2'd2
    } state_t;
    state_t state, next_state;

    // Internal registers
    reg [16:0] SR;               // Shift register: [16:9] remainder, [8:1] quotient bits, [0] unused bit during process
    reg [7:0]  divisor_abs;
    reg [7:0]  dividend_abs;
    reg        dividend_neg;
    reg        divisor_neg;
    reg        quotient_neg;
    reg        remainder_neg;
    reg [3:0]  cnt;

    // Prepare aligned divisor and negated divisor for subtraction (17-bit)
    wire [16:0] divisor_ext = {divisor_abs, 9'd0};   // divisor_abs shifted to bits [16:9]
    wire [16:0] neg_divisor = (~divisor_ext) + 17'd1;

    // Current remainder (9 bits)
    wire [8:0] remainder = SR[16:8];

    // Compute remainder + neg_divisor (i.e., remainder - divisor)
    wire [9:0] sub_res = {1'b0, remainder} + {1'b0, neg_divisor[16:8]};
    wire       sub_success = ~sub_res[9]; // MSB == 0 means no borrow, subtraction successful

    // Next SR computation combinationally
    reg [16:0] SR_next;

    // FSM sequential logic
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
        end else begin
            state <= next_state;
            case(state)
                IDLE: begin
                    res_valid <= 1'b0;
                    if(opn_valid) begin
                        // Extract signs and absolute values
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
                        cnt <= 4'd0;
                    end
                end

                DIVIDE: begin
                    cnt <= cnt + 1'b1;
                    SR <= SR_next;
                end

                DONE: begin
                    // Output stable until next operation
                    res_valid <= 1'b1;
                    // result updated below in combinational block
                end
            endcase
        end
    end

    // FSM next state logic
    always @(*) begin
        case(state)
            IDLE:   next_state = opn_valid ? DIVIDE : IDLE;
            DIVIDE: next_state = (cnt == 4'd8) ? DONE : DIVIDE;
            DONE:   next_state = (opn_valid) ? DIVIDE : DONE;
            default: next_state = IDLE;
        endcase
    end

    // Combinational logic to compute next SR during DIVIDE state
    always @(*) begin
        SR_next = SR << 1;  // Shift left by 1

        if(state == DIVIDE) begin
            if(sub_success) begin
                // subtraction success: update remainder bits with sub_res and set quotient bit = 1
                SR_next[16:8] = sub_res[8:0];
                SR_next[0] = 1'b1; // Set new quotient bit
            end else begin
                // subtraction failed: remainder unchanged (already shifted), quotient bit stays 0
                // SR_next[16:8] remains after shift (upper bits of shifted SR)
                // SR_next[0] = 0 by default from shift
            end
        end else begin
            // Not dividing, keep SR unchanged
            SR_next = SR;
        end
    end

    // Final quotient and remainder extraction and sign correction
    wire [7:0] raw_quotient = SR[8:1];
    wire [7:0] raw_remainder = SR[16:9];

    reg [7:0] corrected_quotient;
    reg [7:0] corrected_remainder;

    always @(*) begin
        if(res_valid) begin
            // Quotient sign correction
            if(quotient_neg)
                corrected_quotient = (~raw_quotient) + 8'd1;
            else
                corrected_quotient = raw_quotient;

            // Remainder sign correction
            if(remainder_neg)
                corrected_remainder = (~raw_remainder) + 8'd1;
            else
                corrected_remainder = raw_remainder;
        end else begin
            corrected_quotient = 8'd0;
            corrected_remainder = 8'd0;
        end
    end

    // Result register updated in DONE state
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            result <= 16'd0;
        end else if(state == DONE) begin
            result <= {corrected_remainder, corrected_quotient};
        end
    end

endmodule