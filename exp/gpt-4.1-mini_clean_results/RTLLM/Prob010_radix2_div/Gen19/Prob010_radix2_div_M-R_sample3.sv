module radix2_div (
    input              clk,
    input              rst,
    input              sign,
    input      [7:0]   dividend,
    input      [7:0]   divisor,
    input              opn_valid,
    output reg         res_valid,
    output reg [15:0]  result  // [15:8] = remainder, [7:0] = quotient
);

    // FSM states
    localparam IDLE   = 2'd0;
    localparam DIVIDE = 2'd1;
    localparam DONE   = 2'd2;

    reg [1:0] state, next_state;

    // Internal registers for absolute values and signs
    reg [7:0] abs_dividend;
    reg [7:0] abs_divisor;
    reg       quotient_sign;
    reg       remainder_sign;

    // Shift register: [16:8] partial remainder (9 bits), [7:0] quotient (8 bits)
    reg [16:0] SR;

    // Iteration counter (1 to 8)
    reg [3:0] cnt;

    // Wires for subtraction
    wire signed [8:0] partial_rem = SR[16:8];
    wire signed [8:0] trial_sub = partial_rem - {1'b0, abs_divisor};

    // Next state logic
    always @(*) begin
        case (state)
            IDLE:
                if (opn_valid)
                    next_state = DIVIDE;
                else
                    next_state = IDLE;
            DIVIDE:
                if (cnt == 4'd8)
                    next_state = DONE;
                else
                    next_state = DIVIDE;
            DONE:
                if (!opn_valid)
                    next_state = IDLE;
                else
                    next_state = DONE;
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state        <= IDLE;
            res_valid    <= 1'b0;
            result       <= 16'd0;
            abs_dividend <= 8'd0;
            abs_divisor  <= 8'd0;
            quotient_sign<= 1'b0;
            remainder_sign<=1'b0;
            SR           <= 17'd0;
            cnt          <= 4'd0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    res_valid <= 1'b0;
                    cnt       <= 4'd0;
                    if (opn_valid) begin
                        // Prepare sign flags
                        quotient_sign  <= sign & (dividend[7] ^ divisor[7]);
                        remainder_sign <= sign & dividend[7];
                        // Compute absolute values
                        abs_dividend <= (sign && dividend[7]) ? (~dividend + 1) : dividend;
                        abs_divisor  <= (sign && divisor[7])  ? (~divisor + 1)  : divisor;
                        // Initialize shift register:
                        // partial remainder = dividend_abs shifted left by 1 (9 bits),
                        // quotient = 0
                        SR <= {abs_dividend, 1'b0, 8'd0};
                        cnt <= 4'd1;
                    end
                end

                DIVIDE: begin
                    if (cnt <= 4'd8) begin
                        if (trial_sub[8] == 1'b0) begin
                            // subtraction successful, shift in '1' quotient bit
                            SR <= {trial_sub[7:0], SR[7:0], 1'b1};
                        end else begin
                            // subtraction unsuccessful, shift in '0' quotient bit and restore partial remainder
                            SR <= {partial_rem[7:0], SR[7:0], 1'b0};
                        end
                        cnt <= cnt + 1'b1;
                    end
                end

                DONE: begin
                    res_valid <= 1'b1;
                    // Assign quotient and remainder with sign correction
                    if (quotient_sign)
                        result[7:0] <= (~SR[7:0]) + 1'b1;
                    else
                        result[7:0] <= SR[7:0];
                    if (remainder_sign)
                        result[15:8] <= (~SR[16:9]) + 1'b1;
                    else
                        result[15:8] <= SR[16:9];
                end
            endcase
        end
    end

endmodule