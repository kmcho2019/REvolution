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

    // State encoding
    localparam IDLE = 2'd0;
    localparam CALC = 2'd1;
    localparam DONE = 2'd2;

    reg [1:0] state, next_state;

    // Registers to hold latched inputs and sign flags
    reg dividend_sign, divisor_sign;
    reg [7:0] dividend_abs, divisor_abs;

    // Shift register holding remainder (upper 8 bits) and quotient (lower 8 bits)
    reg [15:0] sr;

    // Iteration counter (0 to 8)
    reg [3:0] cnt;

    // Combinational signals for subtraction result and borrow
    wire [8:0] sub_res;
    wire borrow;

    // Subtract divisor_abs from remainder (upper 8 bits of sr)
    assign sub_res = {1'b0, sr[15:8]} - {1'b0, divisor_abs};
    assign borrow = sub_res[8];

    // Next values for shift register and counter
    reg [15:0] sr_next;
    reg [3:0]  cnt_next;

    // Next-state logic for FSM
    always @(*) begin
        case(state)
            IDLE: 
                if(opn_valid) 
                    next_state = CALC;
                else 
                    next_state = IDLE;
            CALC: 
                if(cnt == 4'd8)
                    next_state = DONE;
                else
                    next_state = CALC;
            DONE:
                if(opn_valid)
                    next_state = CALC;
                else
                    next_state = DONE;
            default: next_state = IDLE;
        endcase
    end

    // Combinational logic for sr_next and cnt_next during calculation
    always @(*) begin
        sr_next = sr;
        cnt_next = cnt;
        if(state == CALC) begin
            // Shift left by 1 bit
            sr_next = {sr[14:0], 1'b0};
            if(!borrow) begin
                // Subtraction successful, update remainder and set quotient bit to 1
                sr_next[15:8] = sub_res[7:0];
                sr_next[0] = 1'b1;
            end else begin
                // Subtraction failed, remainder unchanged, quotient bit = 0 (already zero after shift)
                // So no further action needed (sr_next already has zero at bit 0)
                // remainder bits unchanged after shift left (will be shifted)
            end
            cnt_next = cnt + 1'b1;
        end
    end

    // Convert signed inputs to absolute values
    wire dividend_sign_w = sign & dividend[7];
    wire divisor_sign_w  = sign & divisor[7];

    wire [7:0] dividend_abs_w = dividend_sign_w ? (~dividend + 8'd1) : dividend;
    wire [7:0] divisor_abs_w  = divisor_sign_w  ? (~divisor + 8'd1)  : divisor;

    // Registers updated on clock
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            state <= IDLE;
            res_valid <= 1'b0;
            result <= 16'd0;
            dividend_sign <= 1'b0;
            divisor_sign <= 1'b0;
            dividend_abs <= 8'd0;
            divisor_abs <= 8'd0;
            sr <= 16'd0;
            cnt <= 4'd0;
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin
                    res_valid <= 1'b0;
                    cnt <= 4'd0;
                    if(opn_valid) begin
                        dividend_sign <= dividend_sign_w;
                        divisor_sign <= divisor_sign_w;
                        dividend_abs <= dividend_abs_w;
                        divisor_abs <= divisor_abs_w;
                        sr <= {dividend_abs_w, 8'd0}; // remainder = dividend_abs, quotient=0
                    end
                end

                CALC: begin
                    sr <= sr_next;
                    cnt <= cnt_next;
                end

                DONE: begin
                    // Compute signed quotient and remainder if needed
                    reg [7:0] quotient;
                    reg [7:0] remainder;

                    quotient = sr[7:0];
                    remainder = sr[15:8];

                    if(sign) begin
                        if(dividend_sign ^ divisor_sign)
                            quotient = (~quotient) + 8'd1;
                        if(dividend_sign)
                            remainder = (~remainder) + 8'd1;
                    end

                    result <= {remainder, quotient};
                    res_valid <= 1'b1;

                    if(opn_valid) begin
                        // Start new operation immediately
                        dividend_sign <= dividend_sign_w;
                        divisor_sign <= divisor_sign_w;
                        dividend_abs <= dividend_abs_w;
                        divisor_abs <= divisor_abs_w;
                        sr <= {dividend_abs_w, 8'd0};
                        cnt <= 4'd0;
                        res_valid <= 1'b0;
                    end
                end

                default: begin
                    state <= IDLE;
                    res_valid <= 1'b0;
                    cnt <= 4'd0;
                    sr <= 16'd0;
                end
            endcase
        end
    end

endmodule