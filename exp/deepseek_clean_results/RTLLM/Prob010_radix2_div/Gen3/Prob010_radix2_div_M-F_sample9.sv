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
    CALC,
    DONE
} state_t;

state_t state;
reg [3:0] cnt;
reg [15:0] SR;       // Shift register: [remainder|quotient]
reg [7:0] dividend_abs;
reg [7:0] divisor_abs;
reg dividend_sign;
reg divisor_sign;
reg div_by_zero;

// Internal signals
wire [7:0] dividend_twos_comp = -dividend;
wire [7:0] divisor_twos_comp = -divisor;
wire [8:0] sub_result = {1'b0, SR[15:8]} + {1'b0, ~divisor_abs + 1'b1};
wire carry_out = ~sub_result[8];  // Positive result means no borrow

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        cnt <= 0;
        SR <= 0;
        res_valid <= 0;
        result <= 0;
        div_by_zero <= 0;
    end else begin
        case (state)
            IDLE: begin
                res_valid <= 0;
                if (opn_valid && !res_valid) begin
                    // Handle division by zero
                    div_by_zero <= (divisor == 0);
                    
                    // Calculate absolute values and signs
                    dividend_sign <= sign & dividend[7];
                    divisor_sign <= sign & divisor[7];
                    dividend_abs <= dividend_sign ? dividend_twos_comp : dividend;
                    divisor_abs <= divisor_sign ? divisor_twos_comp : divisor;
                    
                    // Initialize shift register
                    SR <= {8'b0, dividend_abs};
                    cnt <= 0;
                    state <= div_by_zero ? DONE : CALC;
                end
            end
            
            CALC: begin
                // Perform subtraction and shift
                if (carry_out) begin
                    SR <= {sub_result[7:0], SR[7:0], 1'b1};
                end else begin
                    SR <= {SR[14:0], 1'b0};
                end
                
                // Update counter and state
                if (cnt == 7) begin
                    state <= DONE;
                end
                cnt <= cnt + 1;
            end
            
            DONE: begin
                if (div_by_zero) begin
                    // Handle division by zero case
                    result <= {8'hFF, 8'hFF};
                end else begin
                    // Final result with sign correction
                    result <= {
                        dividend_sign ? -SR[15:8] : SR[15:8],
                        (dividend_sign ^ divisor_sign) ? -SR[7:0] : SR[7:0]
                    };
                end
                res_valid <= 1;
                
                // Ready for next operation
                if (opn_valid) begin
                    state <= IDLE;
                    res_valid <= 0;
                end
            end
        endcase
    end
end

endmodule