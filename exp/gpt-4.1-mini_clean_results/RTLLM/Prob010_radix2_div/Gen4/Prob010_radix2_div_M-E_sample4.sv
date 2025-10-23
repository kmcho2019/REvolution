module radix2_div(
    input              clk,
    input              rst,
    input              sign,          // 1: signed div, 0: unsigned div
    input      [7:0]   dividend,
    input      [7:0]   divisor,
    input              opn_valid,
    output reg         res_valid,
    output reg [15:0]  result          // {remainder[7:0], quotient[7:0]}
);

    // FSM states
    localparam IDLE  = 2'b00;
    localparam CALC  = 2'b01;
    localparam DONE  = 2'b10;

    reg [1:0] state, next_state;

    // Registers to hold absolute values and signs
    reg [7:0] dividend_abs;
    reg [7:0] divisor_abs;
    reg       dividend_neg;
    reg       divisor_neg;

    // Sign flags for correction
    reg       quotient_neg;
    reg       remainder_neg;

    // Iteration counter
    reg [3:0] count;

    // Remainder is 9-bit signed to detect negativity, quotient 8-bit unsigned
    reg [8:0] remainder;
    reg [7:0] quotient;

    // Wires for subtracting divisor_abs from remainder shifted left by 1
    wire [9:0] remainder_shifted_sub; // 10-bit to hold shifted remainder and bit0=0

    wire [8:0] remainder_shifted;
    assign remainder_shifted = {remainder[7:0], 1'b0}; // Shift left by 1

    wire signed [9:0] diff_signed;
    assign diff_signed = {1'b0, remainder_shifted} - {2'b00, divisor_abs};

    // Use diff_signed[9] as sign bit to decide whether subtraction negative (borrow)
    wire subtraction_negative = diff_signed[9];

    // Control FSM
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state       <= IDLE;
            res_valid   <= 1'b0;
            result      <= 16'd0;

            dividend_abs <= 8'd0;
            divisor_abs  <= 8'd0;
            dividend_neg <= 1'b0;
            divisor_neg  <= 1'b0;

            quotient_neg  <= 1'b0;
            remainder_neg <= 1'b0;

            remainder   <= 9'd0;
            quotient    <= 8'd0;
            count       <= 4'd0;
        end else begin
            state <= next_state;
            case(state)
                IDLE: begin
                    res_valid <= 1'b0;
                    if(opn_valid) begin
                        // Determine abs and signs
                        if(sign) begin
                            dividend_neg <= dividend[7];
                            divisor_neg  <= divisor[7];

                            dividend_abs <= dividend[7] ? (~dividend + 1'b1) : dividend;
                            divisor_abs  <= divisor[7] ? (~divisor + 1'b1) : divisor;

                            quotient_neg <= dividend[7] ^ divisor[7];
                            remainder_neg <= dividend[7];
                        end else begin
                            dividend_neg <= 1'b0;
                            divisor_neg  <= 1'b0;
                            dividend_abs <= dividend;
                            divisor_abs  <= divisor;
                            quotient_neg <= 1'b0;
                            remainder_neg <= 1'b0;
                        end
                        // Initialize remainder and quotient
                        remainder <= {1'b0, dividend_abs};
                        quotient <= 8'd0;
                        count <= 4'd0;
                    end
                end
                CALC: begin
                    // Perform one division iteration per cycle
                    // Shift remainder left by 1, then subtract divisor_abs
                    if(!subtraction_negative) begin
                        // subtraction successful: update remainder and set quotient bit = 1
                        remainder <= diff_signed[8:0]; // lower 9 bits contain remainder
                        quotient  <= {quotient[6:0], 1'b1};
                    end else begin
                        // subtraction negative: restore remainder, quotient bit = 0
                        remainder <= remainder_shifted;
                        quotient  <= {quotient[6:0], 1'b0};
                    end
                    count <= count + 1'b1;
                end
                DONE: begin
                    // Sign correction for quotient and remainder
                    reg [7:0] q_out;
                    reg [7:0] r_out;

                    // Quotient correction: if negative, two's complement
                    q_out = quotient_neg ? (~quotient + 1'b1) : quotient;

                    // Remainder correction: if negative, two's complement
                    r_out = remainder_neg ? (~remainder[7:0] + 1'b1) : remainder[7:0];

                    result <= {r_out, q_out};
                    res_valid <= 1'b1;
                end
            endcase

            // Clear res_valid when new operation arrives during DONE
            if (res_valid && opn_valid) begin
                res_valid <= 1'b0;
            end
        end
    end

    // FSM next state logic
    always @(*) begin
        case(state)
            IDLE: begin
                if(opn_valid)
                    next_state = CALC;
                else
                    next_state = IDLE;
            end
            CALC: begin
                if(count == 4'd8)
                    next_state = DONE;
                else
                    next_state = CALC;
            end
            DONE: begin
                if(opn_valid)
                    next_state = CALC;
                else
                    next_state = DONE;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule