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

reg [1:0] state;
reg [7:0] abs_dividend, abs_divisor;
reg [7:0] remainder, quotient;
reg [2:0] cnt;
reg dividend_sign, divisor_sign;
reg div_by_zero;

localparam IDLE = 2'b00;
localparam CALCULATE = 2'b01;
localparam DONE = 2'b10;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        res_valid <= 0;
        result <= 0;
    end else begin
        case (state)
            IDLE: begin
                res_valid <= 0;
                if (opn_valid) begin
                    // Store absolute values and signs
                    dividend_sign <= sign & dividend[7];
                    divisor_sign <= sign & divisor[7];
                    abs_dividend <= dividend_sign ? -dividend : dividend;
                    abs_divisor <= divisor_sign ? -divisor : divisor;
                    div_by_zero <= (divisor == 0);
                    
                    // Initialize calculation
                    remainder <= dividend_sign ? -dividend : dividend;
                    quotient <= 0;
                    cnt <= 0;
                    state <= CALCULATE;
                end
            end
            
            CALCULATE: begin
                if (div_by_zero) begin
                    result <= {8'hFF, 8'hFF}; // Error value
                    state <= DONE;
                end else if (cnt == 7) begin
                    // Final iteration
                    if (remainder >= abs_divisor) begin
                        remainder <= remainder - abs_divisor;
                        quotient <= (quotient << 1) | 1'b1;
                    end else begin
                        quotient <= quotient << 1;
                    end
                    state <= DONE;
                end else begin
                    // Normal iteration
                    if (remainder >= abs_divisor) begin
                        remainder <= remainder - abs_divisor;
                        quotient <= (quotient << 1) | 1'b1;
                    end else begin
                        quotient <= quotient << 1;
                    end
                    cnt <= cnt + 1;
                end
            end
            
            DONE: begin
                // Apply sign correction
                if (!div_by_zero) begin
                    result[15:8] <= dividend_sign ? -remainder : remainder;
                    result[7:0] <= (dividend_sign ^ divisor_sign) ? -quotient : quotient;
                end
                res_valid <= 1;
                state <= IDLE;
            end
        endcase
    end
end

endmodule