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

    // State encoding using localparam
    localparam IDLE   = 2'd0;
    localparam DIVIDE = 2'd1;
    localparam DONE   = 2'd2;

    reg [1:0] state, next_state;

    // Registers for signs and absolute values
    reg dividend_sign, divisor_sign;
    reg quotient_sign, remainder_sign;
    reg [7:0] dividend_abs, divisor_abs;

    // 17-bit shift register:
    // SR[16:8]: remainder (9 bits),
    // SR[7:0]: quotient (8 bits)
    reg [16:0] SR;

    // Iteration counter (0 to 8)
    reg [3:0] count;

    // Temporary registers to hold quotient and remainder before sign correction
    reg [7:0] q_raw;
    reg [7:0] r_raw;

    // Function: absolute value for 8-bit input considering sign mode
    function [7:0] abs8;
        input [7:0] val;
        begin
            if (sign && val[7] == 1'b1)
                abs8 = (~val) + 8'd1;
            else
                abs8 = val;
        end
    endfunction

    // Subtraction signals for current iteration
    wire [8:0] remainder = SR[16:8];
    wire [8:0] divisor_ext = {1'b0, divisor_abs};
    wire [8:0] sub_res = remainder - divisor_ext;
    wire sub_nonneg = ~sub_res[8]; // 1 if remainder >= divisor_abs

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
            q_raw         <= 8'd0;
            r_raw         <= 8'd0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    res_valid <= 1'b0;
                    if (opn_valid) begin
                        // Capture signs
                        dividend_sign <= sign ? dividend[7] : 1'b0;
                        divisor_sign  <= sign ? divisor[7]  : 1'b0;
                        quotient_sign <= sign ? (dividend[7] ^ divisor[7]) : 1'b0;
                        remainder_sign<= sign ? dividend[7] : 1'b0;

                        // Absolute values
                        dividend_abs <= abs8(dividend);
                        divisor_abs  <= abs8(divisor);

                        // Initialize shift register SR:
                        // Put dividend_abs (8 bits) into remainder part (bits 16:9) and 0 at bit 8 (LSB remainder bit)
                        // Quotient (bits 7:0) start at zero
                        // This aligns with initial remainder shifted left by 1 bit (LSB zero)
                        SR <= {dividend_abs, 1'b0, 8'd0};

                        count <= 4'd0;
                    end
                end

                DIVIDE: begin
                    if (divisor_abs == 8'd0) begin
                        // Division by zero: output zeros after finishing
                        count <= 4'd8; // force to done state
                        SR <= 17'd0;
                    end else if (count < 4'd8) begin
                        if (sub_nonneg) begin
                            // Subtract divisor from remainder and shift in quotient bit = 1
                            // sub_res[7:0] is new remainder
                            SR <= {sub_res[7:0], SR[7:0], 1'b1};
                        end else begin
                            // No subtraction, shift in quotient bit = 0
                            SR <= {SR[15:0], 1'b0};
                        end
                        count <= count + 1'b1;
                    end
                end

                DONE: begin
                    if (~res_valid) begin
                        // Extract raw quotient and remainder before sign correction
                        q_raw <= SR[7:0];
                        r_raw <= SR[16:9]; // upper 8 bits of remainder (discard bit 8)
                        res_valid <= 1'b1;
                    end else begin
                        if (~opn_valid) begin
                            // Result consumed, go back to IDLE
                            res_valid <= 1'b0;
                        end
                    end
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (opn_valid)
                    next_state = DIVIDE;
            end

            DIVIDE: begin
                if (count == 4'd8)
                    next_state = DONE;
            end

            DONE: begin
                if (res_valid && ~opn_valid)
                    next_state = IDLE;
            end
        endcase
    end

    // Sign correction combinational logic for output
    // Apply two's complement negation if needed
    wire [7:0] quotient_signed  = (sign && quotient_sign)  ? (~q_raw + 8'd1) : q_raw;
    wire [7:0] remainder_signed = (sign && remainder_sign) ? (~r_raw + 8'd1) : r_raw;

    // Output result assembly when res_valid is high
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            result <= 16'd0;
        end else if (state == DONE && res_valid) begin
            result <= {remainder_signed, quotient_signed};
        end
    end

endmodule