module radix2_div (
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output reg res_valid,
    output reg [15:0] result
);

// State machine definitions
typedef enum logic [1:0] {
    IDLE,
    CALC,
    DONE
} state_t;

state_t current_state, next_state;

// Internal registers
reg [7:0] abs_dividend, abs_divisor;
reg dividend_sign, divisor_sign;
reg [7:0] remainder, quotient;
reg [7:0] neg_divisor;
reg [2:0] cnt;
reg div_by_zero;

// Combinational signals
wire [7:0] dividend_abs = sign & dividend[7] ? -dividend : dividend;
wire [7:0] divisor_abs = sign & divisor[7] ? -divisor : divisor;
wire [7:0] sub_result = remainder + neg_divisor;
wire sub_carry = ~sub_result[7];  // Positive means successful subtraction

// Next state logic
always_comb begin
    next_state = current_state;
    case (current_state)
        IDLE: if (opn_valid && !res_valid) next_state = CALC;
        CALC: if (cnt == 3'd7) next_state = DONE;
        DONE: if (opn_valid) next_state = IDLE;
    endcase
end

// Datapath control
always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        current_state <= IDLE;
        res_valid <= 1'b0;
        result <= 16'd0;
        cnt <= 3'd0;
    end else begin
        current_state <= next_state;
        
        case (current_state)
            IDLE: begin
                res_valid <= 1'b0;
                if (opn_valid && !res_valid) begin
                    abs_dividend <= dividend_abs;
                    abs_divisor <= divisor_abs;
                    dividend_sign <= sign & dividend[7];
                    divisor_sign <= sign & divisor[7];
                    neg_divisor <= -divisor_abs;
                    remainder <= dividend_abs;
                    quotient <= 8'd0;
                    cnt <= 3'd0;
                    div_by_zero <= (divisor_abs == 8'd0);
                end
            end
            
            CALC: begin
                cnt <= cnt + 1;
                remainder <= sub_carry ? sub_result : remainder;
                quotient <= {quotient[6:0], sub_carry};
                if (cnt != 3'd7) begin
                    remainder <= {remainder[6:0], quotient[7]} << 1;
                end
            end
            
            DONE: begin
                res_valid <= 1'b1;
                if (div_by_zero) begin
                    result <= {8'hFF, 8'hFF};
                end else if (sign) begin
                    result <= {
                        dividend_sign ? -remainder : remainder,
                        (dividend_sign ^ divisor_sign) ? -quotient : quotient
                    };
                end else begin
                    result <= {remainder, quotient};
                end
            end
        endcase
    end
end

endmodule