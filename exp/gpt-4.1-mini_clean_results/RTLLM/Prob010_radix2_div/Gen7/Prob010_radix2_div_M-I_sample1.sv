module radix2_div (
    input           clk,
    input           rst,
    input           sign,           // 1: signed, 0: unsigned
    input   [7:0]   dividend,
    input   [7:0]   divisor,
    input           opn_valid,
    output reg      res_valid,
    output reg [15:0] result         // {remainder[7:0], quotient[7:0]}
);

    // FSM states
    localparam IDLE   = 2'b00;
    localparam DIVIDE = 2'b01;
    localparam DONE   = 2'b10;

    reg [1:0] state, next_state;

    // Registers for sign info and absolute values
    reg dividend_sign, divisor_sign;
    reg quotient_sign, remainder_sign;

    reg [7:0] dividend_abs;
    reg [7:0] divisor_abs;

    // Shift register holds remainder(8 bits)+quotient(8 bits)+1 bit for shifting
    // Using 17 bits: [16:8] remainder shifted left by 1, [7:0] quotient
    reg [16:0] SR;

    reg [3:0] count; // iteration counter from 0 to 8

    // Wire for subtraction result: remainder - divisor_abs
    // remainder is upper 9 bits of SR: SR[16:8], divisor_abs zero-extended to 9 bits
    wire [8:0] remainder_ext = SR[16:8];
    wire [8:0] divisor_ext = {1'b0, divisor_abs};
    wire [8:0] sub_res = remainder_ext - divisor_ext;
    wire sub_nonneg = ~sub_res[8]; // 1 if subtraction result >= 0

    // Function: absolute value for 8-bit signed input if sign==1
    function [7:0] abs8;
        input [7:0] val;
        begin
            if (sign && val[7])
                abs8 = (~val) + 8'd1;
            else
                abs8 = val;
        end
    endfunction

    // Synchronous FSM and datapath
    always @(posedge clk) begin
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
                        // Capture signs and compute absolute values
                        dividend_sign <= (sign) ? dividend[7] : 1'b0;
                        divisor_sign  <= (sign) ? divisor[7]  : 1'b0;
                        quotient_sign <= (sign) ? (dividend[7] ^ divisor[7]) : 1'b0;
                        remainder_sign<= (sign) ? dividend[7] : 1'b0;

                        dividend_abs <= abs8(dividend);
                        divisor_abs  <= abs8(divisor);

                        // Initialize SR with dividend_abs shifted left by 1 bit in remainder,
                        // quotient starts at zero
                        // SR[16:8] = {dividend_abs, 1'b0}
                        // SR[7:0] = 0
                        SR <= {dividend_abs, 1'b0, 8'd0};

                        count <= 4'd0;
                    end
                end

                DIVIDE: begin
                    if (divisor_abs == 8'd0) begin
                        // Division by zero: quotient and remainder zero immediately, skip division
                        count <= 4'd8; // force finish
                        SR <= 17'd0;
                    end else begin
                        if (sub_nonneg) begin
                            // subtraction success: update remainder and append '1' to quotient
                            // New remainder = sub_res[7:0]
                            // Shift quotient left by 1, insert '1' LSB
                            // Overall shift left by 1 then insert bit
                            SR <= {sub_res[7:0], SR[7:0], 1'b1};
                        end else begin
                            // subtraction failed: shift left quotient insert '0'
                            SR <= {SR[15:0], 1'b0};
                        end
                        count <= count + 1'b1;
                    end
                end

                DONE: begin
                    if (~res_valid) begin
                        res_valid <= 1'b1;
                        // Compute final result in combinational logic below
                        // Keep SR stable here to preserve remainder and quotient
                    end else if (~opn_valid) begin
                        // Clear res_valid once operation consumed
                        res_valid <= 1'b0;
                    end
                end

                default: ;
            endcase
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

    // Combinational output logic with sign correction
    wire [7:0] raw_quotient = SR[7:0];
    // remainder: upper 9 bits SR[16:8] includes shifted dividend left by 1 bit,
    // final remainder is bits [16:9] (discard bit 8 which is LSB shifted in)
    wire [7:0] raw_remainder = SR[16:9];

    wire [7:0] quotient_signed = (sign && quotient_sign) ? ((~raw_quotient) + 8'd1) : raw_quotient;
    wire [7:0] remainder_signed = (sign && remainder_sign) ? ((~raw_remainder) + 8'd1) : raw_remainder;

    always @(*) begin
        if (state == DONE && res_valid) begin
            result = {remainder_signed, quotient_signed};
        end else begin
            result = result; // Hold stable when not valid
        end
    end

endmodule