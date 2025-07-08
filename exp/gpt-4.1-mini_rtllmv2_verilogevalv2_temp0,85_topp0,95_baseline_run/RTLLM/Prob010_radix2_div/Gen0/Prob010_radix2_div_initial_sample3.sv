module radix2_div (
    input  wire        clk,
    input  wire        rst,
    input  wire        sign,
    input  wire [7:0]  dividend,
    input  wire [7:0]  divisor,
    input  wire        opn_valid,
    output reg         res_valid,
    output reg [15:0]  result
);

// Internal signals and registers
reg [8:0] SR;               // Shift register: remainder(8 bits) + quotient(1 bit)
reg [7:0] ABS_DIVIDEND;
reg [7:0] ABS_DIVISOR;
reg [7:0] NEG_DIVISOR;      // Two's complement of divisor abs value
reg [3:0] cnt;              // 4-bit counter (0 to 8)
reg start_cnt;

reg dividend_sign;
reg divisor_sign;
reg quotient_sign;

wire [8:0] sub_res;
wire       sub_carry_out;

wire [7:0] quotient;
wire [7:0] remainder;

// Step 1: Determine absolute values and signs for signed division
wire [7:0] dividend_abs = (sign && dividend[7]) ? (~dividend + 1) : dividend;
wire [7:0] divisor_abs  = (sign && divisor[7])  ? (~divisor + 1)  : divisor;

wire dividend_sign_w = (sign) ? dividend[7] : 1'b0;
wire divisor_sign_w  = (sign) ? divisor[7]  : 1'b0;

// Subtraction: SR[8:0] + NEG_DIVISOR (two's complement of divisor_abs)
// NEG_DIVISOR = -divisor_abs = (~divisor_abs + 1)
wire [8:0] divisor_ext = {1'b0, ABS_DIVISOR};
wire [8:0] neg_divisor = ~divisor_ext + 9'd1;
assign NEG_DIVISOR = neg_divisor[7:0];

// Compute subtraction: SR[8:0] + NEG_DIVISOR (9 bits)
assign {sub_carry_out, sub_res} = SR + neg_divisor;

// Extract final quotient and remainder after division complete
assign quotient  = SR[7:0];
assign remainder = SR[8:1];

// FSM and arithmetic process
always @(posedge clk) begin
    if (rst) begin
        SR         <= 9'd0;
        cnt        <= 4'd0;
        start_cnt  <= 1'b0;
        res_valid  <= 1'b0;
        result     <= 16'd0;
        ABS_DIVIDEND <= 8'd0;
        ABS_DIVISOR  <= 8'd0;
        NEG_DIVISOR  <= 8'd0;
        dividend_sign <= 1'b0;
        divisor_sign  <= 1'b0;
        quotient_sign <= 1'b0;
    end else begin
        // Operation start
        if (opn_valid && !res_valid) begin
            // Initialize absolute values and signs
            ABS_DIVIDEND  <= dividend_abs;
            ABS_DIVISOR   <= divisor_abs;
            dividend_sign <= dividend_sign_w;
            divisor_sign  <= divisor_sign_w;
            quotient_sign <= dividend_sign_w ^ divisor_sign_w;

            // Initialize SR: dividend_abs shifted left 1 bit (9 bits)
            // Shift left by one bit: dividend_abs * 2
            SR <= {dividend_abs, 1'b0};

            // NEG_DIVISOR: two's complement of divisor_abs (9 bits for subtraction)
            // Calculate in next cycle, so latch divisor_abs here
            // Will calculate NEG_DIVISOR combinationally below

            cnt       <= 4'd1;
            start_cnt <= 1'b1;
            res_valid <= 1'b0;
            result    <= 16'd0;
        end else if (start_cnt) begin
            if (cnt == 4'd8) begin
                // Division complete
                start_cnt <= 1'b0;
                cnt       <= 4'd0;

                // Final remainder and quotient before sign adjustment
                // remainder in SR[8:1], quotient in SR[7:0]

                // For signed division, adjust quotient and remainder sign
                if (sign) begin
                    reg [7:0] adj_quotient;
                    reg [7:0] adj_remainder;

                    // Adjust quotient sign
                    if (quotient_sign)
                        adj_quotient = (~quotient + 1);
                    else
                        adj_quotient = quotient;

                    // Adjust remainder sign (remainder sign = dividend sign)
                    if (dividend_sign)
                        adj_remainder = (~remainder + 1);
                    else
                        adj_remainder = remainder;

                    result <= {adj_remainder, adj_quotient};
                end else begin
                    // Unsigned division: no sign adjustment
                    result <= {remainder, quotient};
                end

                res_valid <= 1'b1;
            end else begin
                // Continue division iterations
                // Compute SR + NEG_DIVISOR (subtraction)

                // If subtraction result positive (sub_carry_out = 1), update SR with sub_res shifted left + 1 at LSB
                // Else restore SR shifted left + 0 at LSB

                if (sub_carry_out) begin
                    // Update SR: (sub_res << 1) | 1
                    SR <= {sub_res[7:0], 1'b1};
                end else begin
                    // Restore SR: (SR << 1) | 0
                    SR <= {SR[7:0], 1'b0};
                end

                cnt <= cnt + 1'b1;
            end
        end else begin
            // When not operating, res_valid remains asserted until next opn_valid
            if (res_valid && opn_valid) begin
                res_valid <= 1'b0;
            end
        end
    end
end

endmodule