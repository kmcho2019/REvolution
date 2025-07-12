module radix2_div (
    input wire clk,
    input wire rst,
    input wire sign,
    input wire [7:0] dividend,
    input wire [7:0] divisor,
    input wire opn_valid,
    output reg res_valid,
    output reg [15:0] result
);

// Pipeline stages
typedef enum logic [1:0] {
    IDLE,
    PREPARE,
    DIVIDE,
    FINISH
} state_t;

// Internal registers
state_t state, next_state;
reg [7:0] dividend_abs, divisor_abs;
reg [15:0] acc;  // {remainder, quotient}
reg [3:0] cnt;
reg q_sign, r_sign;
reg early_term;
reg input_valid;

// Datapath signals
wire [8:0] sub_result = {1'b0, acc[15:8]} + {1'b1, ~divisor_abs + 1'b1};
wire borrow = ~sub_result[8];
wire remainder_zero = (acc[15:8] == 0);
wire division_done = (cnt == 4'd8) || early_term;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        res_valid <= 0;
        result <= 0;
        acc <= 0;
        cnt <= 0;
        q_sign <= 0;
        r_sign <= 0;
        early_term <= 0;
        input_valid <= 0;
    end else begin
        state <= next_state;
        
        // Pipeline stage 1: Input registration and sign handling
        if (state == IDLE && opn_valid) begin
            q_sign <= sign & (dividend[7] ^ divisor[7]);
            r_sign <= sign & dividend[7];
            dividend_abs <= (sign & dividend[7]) ? -dividend : dividend;
            divisor_abs <= (sign & divisor[7]) ? -divisor : divisor;
            input_valid <= 1;
        end else begin
            input_valid <= 0;
        end

        // Pipeline stage 2: Division core
        if (state == PREPARE) begin
            acc <= {8'b0, dividend_abs};
            cnt <= 0;
            early_term <= 0;
        end else if (state == DIVIDE && !division_done) begin
            // Non-restoring division step
            acc <= {acc[14:0], 1'b0};  // Shift left
            
            if (acc[15]) begin
                // Remainder was negative - add divisor
                acc[15:8] <= acc[15:8] + divisor_abs;
            end else begin
                // Remainder was positive - subtract divisor
                acc[15:8] <= acc[15:8] - divisor_abs;
            end
            
            // Set quotient bit based on borrow
            acc[0] <= ~(acc[15] ^ (cnt == 0 ? 1'b0 : acc[0]));
            
            cnt <= cnt + 1;
            early_term <= remainder_zero;
        end

        // Result formatting
        if (state == FINISH) begin
            // Correct negative remainder if needed
            if (acc[15]) begin
                acc[15:8] <= acc[15:8] + divisor_abs;
            end
            
            // Apply sign correction if signed operation
            if (sign) begin
                acc[7:0] <= q_sign ? -acc[7:0] : acc[7:0];
                acc[15:8] <= r_sign ? -acc[15:8] : acc[15:8];
            end
            
            result <= acc;
            res_valid <= 1;
        end else begin
            res_valid <= 0;
        end
    end
end

// Next state logic
always_comb begin
    case (state)
        IDLE: next_state = (opn_valid) ? PREPARE : IDLE;
        PREPARE: next_state = DIVIDE;
        DIVIDE: next_state = (division_done) ? FINISH : DIVIDE;
        FINISH: next_state = IDLE;
        default: next_state = IDLE;
    endcase
end

endmodule