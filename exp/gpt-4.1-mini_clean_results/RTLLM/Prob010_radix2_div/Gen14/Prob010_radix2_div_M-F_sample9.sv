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
    // Initially remainder = 0, quotient = abs_dividend
    reg [16:0] SR;

    // Counter for division steps (1 to 8)
    reg [3:0] cnt;

    // Wires for subtraction
    wire [8:0] remainder_part;
    wire [8:0] sub_res;
    wire       borrow;

    assign remainder_part = SR[16:8];

    // Subtract divisor from remainder_part
    assign {borrow, sub_res} = {1'b0, remainder_part} - {1'b0, abs_divisor};

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
                    cnt <= 4'd0;
                    if (opn_valid) begin
                        // Save signs and compute absolute values
                        dividend_neg <= sign & dividend[7];
                        divisor_neg  <= sign & divisor[7];

                        abs_dividend <= (sign && dividend[7]) ? (~dividend + 1'b1) : dividend;
                        abs_divisor  <= (sign && divisor[7])  ? (~divisor + 1'b1)  : divisor;

                        // Initialize shift register: remainder=0, quotient=abs_dividend
                        SR <= {9'd0, abs_dividend};
                    end
                end

                RUNNING: begin
                    if (cnt < 4'd8) begin
                        // Perform one division step:
                        // Subtract divisor from remainder part
                        // If no borrow, update remainder to sub_res and set quotient bit to 1
                        // Else keep remainder and set quotient bit to 0
                        // Shift SR left by 1, inserting quotient bit at LSB

                        if (~borrow) begin
                            // subtraction succeeded
                            // shift left and insert quotient bit = 1
                            SR <= {sub_res[7:0], SR[7:0], 1'b1};
                        end else begin
                            // subtraction failed
                            // shift left and insert quotient bit = 0
                            SR <= {remainder_part[7:0], SR[7:0], 1'b0};
                        end
                        cnt <= cnt + 1'b1;
                    end
                end

                DONE: begin
                    res_valid <= 1'b1;
                    // Hold final results stable until next operation
                end

                default: ;
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case(state)
            IDLE:    next_state = opn_valid ? RUNNING : IDLE;
            RUNNING: next_state = (cnt == 4'd8) ? DONE : RUNNING;
            DONE:    next_state = (!res_valid) ? IDLE : (opn_valid ? RUNNING : DONE);
            default: next_state = IDLE;
        endcase
    end

    // Combinational block to assign final signed quotient and remainder after division completes
    always @(*) begin
        if (state == DONE) begin
            // Extract quotient and remainder from SR
            // remainder = bits [16:9] (8 bits)
            // quotient = bits [7:0]

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

            // Assign to output
            result = {final_remainder, final_quotient};
        end else begin
            result = 16'd0;
            final_quotient = 8'd0;
            final_remainder = 8'd0;
        end
    end

endmodule