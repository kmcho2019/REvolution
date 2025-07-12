module radix2_div (
    input             clk,
    input             rst,
    input             sign,
    input      [7:0]  dividend,
    input      [7:0]  divisor,
    input             opn_valid,
    output reg        res_valid,
    output reg [15:0] result
);

    // FSM States
    typedef enum logic [1:0] {
        IDLE   = 2'd0,
        DIVIDE = 2'd1,
        DONE   = 2'd2
    } state_t;

    state_t state, next_state;

    // Registers for signs and absolute values
    reg dividend_sign, divisor_sign;
    reg quotient_sign, remainder_sign;
    reg [7:0] dividend_abs, divisor_abs;

    // 17-bit shift register:
    // SR[16:8]: remainder (9 bits),
    // SR[7:0]: quotient (8 bits)
    reg [16:0] SR;

    // Iteration counter
    reg [3:0] count;

    // Combinational signals for subtraction
    wire [8:0] remainder   = SR[16:8];
    wire [8:0] divisor_ext = {1'b0, divisor_abs};
    wire [8:0] sub_res     = remainder - divisor_ext;
    wire        sub_nonneg = ~sub_res[8]; // 1 if sub_res >= 0

    // Function to get absolute value considering sign
    function [7:0] abs8(input [7:0] val);
        if (sign && val[7])
            abs8 = (~val + 8'd1);
        else
            abs8 = val;
    endfunction

    // Sequential FSM and datapath
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state         <= IDLE;
            res_valid     <= 1'b0;
            result        <= 16'd0;
            dividend_sign <= 1'b0;
            divisor_sign  <= 1'b0;
            quotient_sign <= 1'b0;
            remainder_sign<= 1'b0;
            dividend_abs  <= 8'd0;
            divisor_abs   <= 8'd0;
            SR            <= 17'd0;
            count         <= 4'd0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    res_valid <= 1'b0;
                    if (opn_valid) begin
                        // Capture signs
                        dividend_sign <= (sign) ? dividend[7] : 1'b0;
                        divisor_sign  <= (sign) ? divisor[7]  : 1'b0;
                        quotient_sign <= (sign) ? (dividend[7] ^ divisor[7]) : 1'b0;
                        remainder_sign<= (sign) ? dividend[7] : 1'b0;

                        // Absolute values
                        dividend_abs <= abs8(dividend);
                        divisor_abs  <= abs8(divisor);

                        // Initialize SR: remainder = dividend_abs (9 bits with 0 padding LSB), quotient=0
                        // remainder shifted left by 1 bit with LSB 0 => SR = {dividend_abs, 1'b0, 8'd0}
                        // Actually, to start division properly, shift dividend_abs left by 1
                        SR <= {dividend_abs, 1'b0, 8'd0};

                        count <= 4'd0;
                    end
                end

                DIVIDE: begin
                    if (divisor_abs == 8'd0) begin
                        // Division by zero: remainder and quotient remain 0
                        count <= 4'd8; // force to done
                    end else begin
                        // Subtract divisor from remainder part if possible
                        if (sub_nonneg) begin
                            // Update remainder with subtraction result
                            // Shift SR left by 1, inserting quotient bit 1
                            // sub_res is 9 bits, but only 8 bits stored in remainder, MSB is sign bit not stored
                            SR <= {sub_res[7:0], SR[7:0], 1'b1};
                        end else begin
                            // Keep remainder, shift left inserting quotient bit 0
                            SR <= {SR[15:0], 1'b0};
                        end
                        count <= count + 4'd1;
                    end
                end

                DONE: begin
                    if (res_valid) begin
                        // Wait for new operation, keep result stable until consumed
                        if (~opn_valid) begin
                            res_valid <= 1'b0;
                        end
                    end else begin
                        res_valid <= 1'b1;

                        // Extract raw quotient and remainder before sign correction
                        reg [7:0] q_raw;
                        reg [7:0] r_raw;

                        q_raw = SR[7:0];
                        r_raw = SR[16:9]; // upper 8 bits of remainder (discard bit 8)

                        // Sign corrections if signed operation
                        if (sign) begin
                            if (quotient_sign)
                                q_raw = (~q_raw + 8'd1);
                            if (remainder_sign)
                                r_raw = (~r_raw + 8'd1);
                        end

                        result <= {r_raw, q_raw};
                    end
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE:
                if (opn_valid)
                    next_state = DIVIDE;
            DIVIDE:
                if (count == 4'd8)
                    next_state = DONE;
            DONE:
                if (res_valid && ~opn_valid)
                    next_state = IDLE;
        endcase
    end

endmodule