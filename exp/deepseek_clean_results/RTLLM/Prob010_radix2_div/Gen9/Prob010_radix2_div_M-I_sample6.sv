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

reg [15:0] SR;          // Shift register: [remainder|quotient]
reg [7:0] NEG_DIVISOR;  // Negative of absolute divisor
reg [3:0] cnt;          // 4-bit counter (0-8)
reg start_cnt;          // Start counting flag
reg div_by_zero;        // Division by zero flag
reg dividend_sign;      // Sign of dividend
reg divisor_sign;       // Sign of divisor

localparam IDLE = 1'b0;
localparam CALC = 1'b1;
reg state;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        res_valid <= 0;
        result <= 0;
        SR <= 0;
        cnt <= 0;
        start_cnt <= 0;
        div_by_zero <= 0;
    end else begin
        case (state)
            IDLE: begin
                res_valid <= 0;
                if (opn_valid && !res_valid) begin
                    // Store signs and absolute values
                    dividend_sign <= sign & dividend[7];
                    divisor_sign <= sign & divisor[7];
                    
                    // Initialize shift register with dividend << 1
                    SR <= {(dividend_sign ? -dividend : dividend), 8'b0};
                    
                    // Store negative of absolute divisor
                    NEG_DIVISOR <= -(divisor_sign ? -divisor : divisor);
                    
                    div_by_zero <= (divisor == 0);
                    cnt <= 0;
                    start_cnt <= 1;
                    state <= CALC;
                end
            end
            
            CALC: begin
                if (start_cnt) begin
                    if (div_by_zero) begin
                        // Handle division by zero
                        result <= {8'hFF, 8'hFF};
                        res_valid <= 1;
                        state <= IDLE;
                    end else if (cnt[3]) begin  // cnt == 8
                        // Final result
                        if (SR[15:8] >= (~NEG_DIVISOR + 1)) begin
                            SR[15:8] <= SR[15:8] + NEG_DIVISOR;
                            SR <= {SR[14:0], 1'b1};
                        end else begin
                            SR <= {SR[14:0], 1'b0};
                        end
                        
                        // Apply sign correction
                        result[15:8] <= dividend_sign ? -SR[15:8] : SR[15:8];
                        result[7:0] <= (dividend_sign ^ divisor_sign) ? -SR[7:0] : SR[7:0];
                        
                        res_valid <= 1;
                        start_cnt <= 0;
                        state <= IDLE;
                    end else begin
                        // Normal iteration
                        if (SR[15:8] >= (~NEG_DIVISOR + 1)) begin
                            SR[15:8] <= SR[15:8] + NEG_DIVISOR;
                            SR <= {SR[14:0], 1'b1};
                        end else begin
                            SR <= {SR[14:0], 1'b0};
                        end
                        cnt <= cnt + 1;
                    end
                end
            end
        endcase
    end
end

endmodule