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

reg [7:0] abs_dividend, abs_divisor;
reg dividend_sign, divisor_sign;
reg [15:0] SR; // Shift register (remainder|quotient)
reg [7:0] NEG_DIVISOR;
reg [3:0] cnt;
reg start_cnt;
reg [1:0] state;

localparam IDLE = 2'b00;
localparam CALC = 2'b01;
localparam DONE = 2'b10;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
        result <= 0;
        cnt <= 0;
        start_cnt <= 0;
        state <= IDLE;
    end else begin
        case (state)
            IDLE: begin
                res_valid <= 0;
                if (opn_valid && !res_valid) begin
                    // Handle signed inputs
                    dividend_sign <= sign & dividend[7];
                    divisor_sign <= sign & divisor[7];
                    
                    abs_dividend <= dividend_sign ? -dividend : dividend;
                    abs_divisor <= divisor_sign ? -divisor : divisor;
                    
                    // Initialize shift register
                    SR <= {8'b0, abs_dividend} << 1;
                    NEG_DIVISOR <= -(divisor_sign ? -divisor : divisor);
                    cnt <= 1;
                    start_cnt <= 1;
                    state <= CALC;
                end
            end
            
            CALC: begin
                if (start_cnt) begin
                    if (cnt[3]) begin // cnt == 8
                        // Final result handling
                        start_cnt <= 0;
                        cnt <= 0;
                        
                        // Sign correction
                        if (sign) begin
                            SR[7:0] <= (dividend_sign ^ divisor_sign) ? -SR[7:0] : SR[7:0];
                            SR[15:8] <= dividend_sign ? -SR[15:8] : SR[15:8];
                        end
                        
                        state <= DONE;
                    end else begin
                        // Perform subtraction and shift
                        if (SR[15:8] + NEG_DIVISOR >= 0) begin
                            SR <= {SR[15:8] + NEG_DIVISOR, SR[7:0], 1'b1};
                        end else begin
                            SR <= {SR[15:0], 1'b0};
                        end
                        cnt <= cnt + 1;
                    end
                end
            end
            
            DONE: begin
                result <= {SR[15:8], SR[7:0]};
                res_valid <= 1;
                if (!opn_valid) begin
                    res_valid <= 0;
                    state <= IDLE;
                end
            end
        endcase
    end
end

endmodule