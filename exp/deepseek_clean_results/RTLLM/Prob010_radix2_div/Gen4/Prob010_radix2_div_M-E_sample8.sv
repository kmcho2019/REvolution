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

// States
typedef enum logic [1:0] {
    IDLE,
    PREPARE,
    DIVIDE,
    CORRECT
} state_t;

reg [1:0] state, next_state;

// Internal registers
reg [7:0] abs_dividend, abs_divisor;
reg [15:0] partial_remainder;
reg [7:0] quotient;
reg [3:0] cycle_count;
reg dividend_sign, divisor_sign;
reg division_by_zero;
reg early_complete;

// Parallel remainder paths
wire [8:0] pos_rem = {partial_remainder[14:7], 1'b0} + {1'b0, abs_divisor};
wire [8:0] neg_rem = {partial_remainder[14:7], 1'b0} - {1'b0, abs_divisor};

// Sign prediction
wire rem_sign = partial_remainder[15];
wire next_pos_sign = pos_rem[8];
wire next_neg_sign = neg_rem[8];

// Early termination detection
wire trivial_case = (abs_divisor == 0) || (abs_divisor == 1) || (abs_dividend == 0);

// Next state logic
always @(*) begin
    case (state)
        IDLE: next_state = opn_valid ? PREPARE : IDLE;
        PREPARE: next_state = DIVIDE;
        DIVIDE: next_state = (cycle_count == 8 || early_complete) ? CORRECT : DIVIDE;
        CORRECT: next_state = IDLE;
        default: next_state = IDLE;
    endcase
end

// Datapath
always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        res_valid <= 0;
        result <= 0;
        partial_remainder <= 0;
        quotient <= 0;
        cycle_count <= 0;
    end else begin
        state <= next_state;
        
        case (state)
            IDLE: begin
                res_valid <= 0;
                if (opn_valid) begin
                    dividend_sign <= sign & dividend[7];
                    divisor_sign <= sign & divisor[7];
                    abs_dividend <= dividend_sign ? -dividend : dividend;
                    abs_divisor <= divisor_sign ? -divisor : divisor;
                    division_by_zero <= (divisor == 0);
                end
            end
            
            PREPARE: begin
                partial_remainder <= {8'b0, abs_dividend};
                quotient <= 0;
                cycle_count <= 0;
                early_complete <= trivial_case;
            end
            
            DIVIDE: begin
                if (!early_complete) begin
                    // Select remainder path based on current sign
                    if (rem_sign) begin
                        partial_remainder <= {pos_rem[7:0], partial_remainder[6:0], 1'b0};
                        quotient <= {quotient[6:0], ~next_pos_sign};
                    end else begin
                        partial_remainder <= {neg_rem[7:0], partial_remainder[6:0], 1'b0};
                        quotient <= {quotient[6:0], next_neg_sign};
                    end
                    cycle_count <= cycle_count + 1;
                end
            end
            
            CORRECT: begin
                if (division_by_zero) begin
                    result <= 16'hFFFF; // Division by zero flag
                end else if (abs_divisor == 1) begin
                    // Special case: divisor = 1
                    result[7:0] <= (dividend_sign ^ divisor_sign) ? -abs_dividend : abs_dividend;
                    result[15:8] <= dividend_sign ? -8'b0 : 8'b0;
                end else if (abs_dividend == 0) begin
                    // Special case: dividend = 0
                    result <= 0;
                end else begin
                    // Final remainder correction
                    if (partial_remainder[15]) begin
                        partial_remainder[15:8] <= partial_remainder[15:8] + abs_divisor;
                    end
                    
                    // Apply signs to results
                    result[7:0] <= (dividend_sign ^ divisor_sign) ? -quotient : quotient;
                    result[15:8] <= dividend_sign ? -partial_remainder[15:8] : partial_remainder[15:8];
                end
                res_valid <= 1;
            end
        endcase
    end
end

// Optimized leading-one detector for adaptive shifting
function [2:0] leading_ones;
    input [7:0] val;
    begin
        casez (val)
            8'b1???????: leading_ones = 0;
            8'b01??????: leading_ones = 1;
            8'b001?????: leading_ones = 2;
            8'b0001????: leading_ones = 3;
            8'b00001???: leading_ones = 4;
            8'b000001??: leading_ones = 5;
            8'b0000001?: leading_ones = 6;
            8'b00000001: leading_ones = 7;
            default: leading_ones = 7;
        endcase
    end
endfunction

endmodule