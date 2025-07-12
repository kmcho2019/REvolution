module radix2_div #(
    parameter WIDTH = 8
) (
    input wire clk,
    input wire rst,
    input wire sign,
    input wire [WIDTH-1:0] dividend,
    input wire [WIDTH-1:0] divisor,
    input wire opn_valid,
    output reg res_valid,
    output reg [2*WIDTH-1:0] result,
    output reg error          // New output for division by zero
);

localparam IDLE = 1'b0;
localparam CALC = 1'b1;

reg state;
reg [2*WIDTH:0] SR;          // Shift register: [1 extra bit|remainder|quotient]
reg [WIDTH-1:0] NEG_DIVISOR; // Negative of absolute divisor
reg [3:0] cnt;               // 4-bit counter (0-8)
reg dividend_sign;           // Sign of dividend
reg divisor_sign;            // Sign of divisor

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        res_valid <= 0;
        result <= 0;
        SR <= 0;
        cnt <= 0;
        error <= 0;
    end else begin
        case (state)
            IDLE: begin
                res_valid <= 0;
                error <= 0;
                if (opn_valid && !res_valid) begin
                    // Store signs and check for division by zero
                    dividend_sign <= sign & dividend[WIDTH-1];
                    divisor_sign <= sign & divisor[WIDTH-1];
                    
                    if (divisor == 0) begin
                        // Division by zero case
                        error <= 1;
                        res_valid <= 1;
                        result <= {2*WIDTH{1'b1}}; // All ones as error value
                    end else begin
                        // Initialize shift register with dividend << 1
                        SR <= {1'b0, (dividend_sign ? -dividend : dividend), {WIDTH{1'b0}}};
                        
                        // Store negative of absolute divisor
                        NEG_DIVISOR <= -(divisor_sign ? -divisor : divisor);
                        
                        cnt <= 0;
                        state <= CALC;
                    end
                end
            end
            
            CALC: begin
                if (cnt == WIDTH) begin
                    // Final result processing
                    // Apply sign correction
                    result[2*WIDTH-1:WIDTH] <= dividend_sign ? -SR[2*WIDTH-1:WIDTH] : SR[2*WIDTH-1:WIDTH];
                    result[WIDTH-1:0] <= (dividend_sign ^ divisor_sign) ? -SR[WIDTH-1:0] : SR[WIDTH-1:0];
                    
                    res_valid <= 1;
                    state <= IDLE;
                end else begin
                    // Division iteration
                    if (SR[2*WIDTH:WIDTH] >= {1'b0, ~NEG_DIVISOR + 1'b1}) begin
                        SR[2*WIDTH:WIDTH] <= SR[2*WIDTH:WIDTH] + {1'b0, NEG_DIVISOR};
                        SR <= {SR[2*WIDTH-1:0], 1'b1};
                    end else begin
                        SR <= {SR[2*WIDTH-1:0], 1'b0};
                    end
                    cnt <= cnt + 1;
                end
            end
        endcase
    end
end

endmodule