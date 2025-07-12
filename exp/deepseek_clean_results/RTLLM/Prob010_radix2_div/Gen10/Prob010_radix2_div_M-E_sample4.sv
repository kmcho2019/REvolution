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

// Internal registers
reg [7:0] abs_dividend, abs_divisor;
reg [7:0] quotient, remainder;
reg [7:0] neg_divisor;
reg dividend_sign, divisor_sign;
reg [3:0] cycle;
reg running;
reg zero_divisor;

// Buffered inputs
reg [7:0] buff_dividend, buff_divisor;
reg buff_sign;
reg buff_valid;

// State machine
localparam IDLE = 0;
localparam SETUP = 1;
localparam DIVIDE = 2;
localparam FINISH = 3;
reg [1:0] state;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        res_valid <= 0;
        result <= 0;
        quotient <= 0;
        remainder <= 0;
        cycle <= 0;
        running <= 0;
        buff_valid <= 0;
    end else begin
        case (state)
            IDLE: begin
                res_valid <= 0;
                if (opn_valid) begin
                    // Buffer inputs
                    buff_dividend <= dividend;
                    buff_divisor <= divisor;
                    buff_sign <= sign;
                    buff_valid <= 1;
                    state <= SETUP;
                end
            end
            
            SETUP: begin
                if (buff_valid) begin
                    // Calculate absolute values and signs
                    dividend_sign = buff_sign & buff_dividend[7];
                    divisor_sign = buff_sign & buff_divisor[7];
                    
                    abs_dividend = dividend_sign ? -buff_dividend : buff_dividend;
                    abs_divisor = divisor_sign ? -buff_divisor : buff_divisor;
                    neg_divisor = -abs_divisor;
                    
                    zero_divisor = (abs_divisor == 0);
                    remainder = abs_dividend;
                    quotient = 0;
                    cycle = 0;
                    running = 1;
                    
                    buff_valid <= 0;
                    state <= DIVIDE;
                end
            end
            
            DIVIDE: begin
                if (running) begin
                    if (zero_divisor) begin
                        // Handle division by zero
                        quotient <= 8'hFF;
                        remainder <= 8'hFF;
                        running <= 0;
                        state <= FINISH;
                    end else if (cycle == 8) begin
                        // Final iteration
                        if (remainder[7]) begin
                            remainder <= remainder + abs_divisor;
                            quotient <= {quotient[6:0], 1'b0};
                        end else begin
                            quotient <= {quotient[6:0], 1'b1};
                        end
                        running <= 0;
                        state <= FINISH;
                    end else begin
                        // Normal iteration
                        if (remainder[7]) begin
                            remainder <= {remainder[6:0], quotient[7]} + abs_divisor;
                        end else begin
                            remainder <= {remainder[6:0], quotient[7]} + neg_divisor;
                        end
                        quotient <= {quotient[6:0], ~remainder[7]};
                        cycle <= cycle + 1;
                    end
                end
            end
            
            FINISH: begin
                // Apply sign correction
                result[15:8] <= dividend_sign ? -remainder : remainder;
                result[7:0] <= (dividend_sign ^ divisor_sign) ? -quotient : quotient;
                res_valid <= 1;
                state <= IDLE;
            end
        endcase
        
        // Accept new operation while finishing current
        if (opn_valid && state != IDLE && !buff_valid) begin
            buff_dividend <= dividend;
            buff_divisor <= divisor;
            buff_sign <= sign;
            buff_valid <= 1;
        end
    end
end

endmodule