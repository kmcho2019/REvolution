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

// FSM states
typedef enum logic [1:0] {
    IDLE,
    CALC,
    DONE
} state_t;

// Internal registers
state_t state;
reg [7:0] dividend_abs;
reg [7:0] divisor_abs;
reg [15:0] acc;          // Accumulator (remainder | quotient)
reg [3:0] cnt;           // Iteration counter
reg q_sign;              // Quotient sign
reg r_sign;              // Remainder sign
reg special_case;        // Flag for div by 0/1

// Datapath signals
wire [8:0] sub_result = {acc[15:8], 1'b0} + {1'b1, ~divisor_abs, 1'b1}; // 2's complement sub
wire borrow = ~sub_result[8]; // Borrow flag (1 if subtraction was negative)

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        res_valid <= 0;
        result <= 16'b0;
        acc <= 16'b0;
        cnt <= 0;
        q_sign <= 0;
        r_sign <= 0;
        special_case <= 0;
    end else begin
        case (state)
            IDLE: begin
                res_valid <= 0;
                if (opn_valid) begin
                    // Handle sign and special cases
                    q_sign <= sign & (dividend[7] ^ divisor[7]);
                    r_sign <= sign & dividend[7];
                    
                    // Calculate absolute values
                    dividend_abs <= sign & dividend[7] ? -dividend : dividend;
                    divisor_abs <= sign & divisor[7] ? -divisor : divisor;
                    
                    // Check for special cases
                    if (divisor_abs == 0) begin
                        // Division by zero - max value for quotient
                        acc <= {8'b0, 8'hFF};
                        special_case <= 1;
                        state <= DONE;
                    end else if (divisor_abs == 1) begin
                        // Division by one - quotient equals dividend
                        acc <= {8'b0, dividend_abs};
                        special_case <= 1;
                        state <= DONE;
                    end else begin
                        // Normal division
                        acc <= {8'b0, dividend_abs};
                        cnt <= 0;
                        special_case <= 0;
                        state <= CALC;
                    end
                end
            end
            
            CALC: begin
                if (cnt == 8) begin
                    // Final iteration
                    if (acc[15]) begin // If remainder is negative
                        acc[15:8] <= acc[15:8] + divisor_abs; // Restore
                    end
                    state <= DONE;
                end else begin
                    // Non-restoring division step
                    if (acc[15]) begin
                        // Remainder was negative - add
                        acc <= {acc[14:0], 1'b0} + {divisor_abs, 8'b0};
                    end else begin
                        // Remainder was positive - subtract
                        acc <= {acc[14:0], 1'b0} + {~divisor_abs + 1, 8'b0};
                    end
                    cnt <= cnt + 1;
                end
            end
            
            DONE: begin
                // Apply sign correction if needed
                if (sign && !special_case) begin
                    acc[7:0] <= q_sign ? -acc[7:0] : acc[7:0];
                    acc[15:8] <= r_sign ? -acc[15:8] : acc[15:8];
                end
                result <= acc;
                res_valid <= 1;
                state <= IDLE;
            end
        endcase
    end
end

endmodule