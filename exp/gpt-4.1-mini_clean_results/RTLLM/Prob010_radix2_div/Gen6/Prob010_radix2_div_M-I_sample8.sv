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

    // FSM states (traditional Verilog parameters)
    parameter IDLE   = 2'd0;
    parameter DIVIDE = 2'd1;
    parameter DONE   = 2'd2;

    reg [1:0] state, next_state;

    // Registers for operand signs and absolute values
    reg dividend_sign;
    reg divisor_sign;
    reg quotient_sign;
    reg remainder_sign;

    reg [7:0] dividend_abs;
    reg [7:0] divisor_abs;

    // 17-bit shift register: SR[16:8] remainder (9 bits), SR[7:0] quotient (8 bits)
    reg [16:0] SR;

    // Iteration counter (0 to 8)
    reg [3:0] count;

    // Temporary variables for subtraction result and decision signals
    wire [8:0] remainder = SR[16:8];
    wire [8:0] divisor_ext = {1'b0, divisor_abs};
    wire [8:0] sub_res = remainder - divisor_ext;
    wire sub_nonneg = ~sub_res[8]; // 1 if sub_res >= 0

    // Intermediate registers for DONE state outputs
    reg [7:0] q_raw;
    reg [7:0] r_raw;

    // Function to get absolute value (with proper begin/end)
    function [7:0] abs8;
        input [7:0] val;
        begin
            if (sign && val[7])
                abs8 = (~val + 8'd1);
            else
                abs8 = val;
        end
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
            q_raw         <= 8'd0;
            r_raw         <= 8'd0;
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

                        // Compute absolute values
                        dividend_abs <= abs8(dividend);
                        divisor_abs  <= abs8(divisor);

                        // Initialize SR: remainder (9 bits) = dividend_abs shifted left by 1 (with LSB zero), quotient = 0
                        // remainder has 9 bits to hold shifted dividend abs, so SR[16:8] = {dividend_abs, 1'b0}
                        SR <= {dividend_abs, 1'b0, 8'd0};

                        count <= 4'd0;

                        // Clear output registers
                        q_raw <= 8'd0;
                        r_raw <= 8'd0;
                    end
                end

                DIVIDE: begin
                    if (divisor_abs == 8'd0) begin
                        // Division by zero: force count to 8 to end division immediately
                        count <= 4'd8;
                        // Keep SR unchanged (quotient and remainder zero)
                        SR <= 17'd0;
                    end else begin
                        // Perform subtraction and shift for this iteration
                        if (sub_nonneg) begin
                            // Successful subtraction: update remainder with sub_res and shift left insert 1 to quotient LSB
                            SR <= {sub_res[7:0], SR[7:0], 1'b1};
                        end else begin
                            // Subtraction failed: shift left, insert 0 to quotient LSB
                            SR <= {SR[15:0], 1'b0};
                        end
                        count <= count + 4'd1;
                    end
                end

                DONE: begin
                    if (~res_valid) begin
                        // On first cycle in DONE: output final quotient and remainder with sign correction

                        // Extract raw quotient and remainder (from SR)
                        // remainder is upper 9 bits: SR[16:8], but we only store 8 bits remainder in output,
                        // dropping the lowest bit as the algorithm shifts dividend left by 1 at start
                        q_raw <= SR[7:0];
                        r_raw <= SR[16:9]; // MSB down to bit 9 (discard bit 8)

                        // Apply sign correction in combinational way below (assign result)

                        res_valid <= 1'b1;
                    end else begin
                        // Wait for opn_valid deassertion to clear res_valid and go back to IDLE
                        if (~opn_valid)
                            res_valid <= 1'b0;
                    end
                end
            endcase
        end
    end

    // Combinational logic for result sign correction and assignment
    always @(*) begin
        if (state == DONE && res_valid) begin
            // Default no sign change
            reg [7:0] q_signed, r_signed;
            q_signed = q_raw;
            r_signed = r_raw;

            if (sign) begin
                if (quotient_sign)
                    q_signed = (~q_raw + 8'd1);
                if (remainder_sign)
                    r_signed = (~r_raw + 8'd1);
            end
            result = {r_signed, q_signed};
        end else begin
            // When not DONE or res_valid low, keep result stable
            result = result;
        end
    end

    // FSM next state logic
    always @(*) begin
        case (state)
            IDLE:
                next_state = (opn_valid) ? DIVIDE : IDLE;
            DIVIDE:
                next_state = (count == 4'd8) ? DONE : DIVIDE;
            DONE:
                next_state = (res_valid && ~opn_valid) ? IDLE : DONE;
            default:
                next_state = IDLE;
        endcase
    end

endmodule