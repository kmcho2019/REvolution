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

// Parameters
parameter WIDTH = 8;
parameter ITERATIONS = 8;

// States
localparam IDLE = 1'b0;
localparam CALC = 1'b1;

// Internal registers
reg state;
reg [WIDTH-1:0] dividend_abs;
reg [WIDTH-1:0] divisor_abs;
reg [2*WIDTH:0] acc;  // {1'b0, remainder, quotient}
reg [3:0] cnt;
reg q_sign, r_sign;
reg special_case;

// Datapath signals
wire [WIDTH:0] sub_result = {1'b0, acc[2*WIDTH-1:WIDTH]} + {1'b1, ~divisor_abs + 1'b1};
wire borrow = ~sub_result[WIDTH];

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        res_valid <= 0;
        result <= 0;
        acc <= 0;
        cnt <= 0;
        q_sign <= 0;
        r_sign <= 0;
        special_case <= 0;
    end else begin
        case (state)
            IDLE: begin
                res_valid <= 0;
                if (opn_valid && !res_valid) begin
                    // Sign handling and absolute value calculation
                    q_sign <= sign & (dividend[WIDTH-1] ^ divisor[WIDTH-1]);
                    r_sign <= sign & dividend[WIDTH-1];
                    dividend_abs <= (sign & dividend[WIDTH-1]) ? -dividend : dividend;
                    divisor_abs <= (sign & divisor[WIDTH-1]) ? -divisor : divisor;
                    
                    // Special case detection
                    if (divisor == 0) begin
                        // Divide by zero - max quotient, remainder = dividend
                        result <= {dividend, {WIDTH{1'b1}}};
                        res_valid <= 1;
                    end else if (divisor_abs == 1) begin
                        // Divide by one - quotient = dividend, remainder = 0
                        result <= {8'b0, dividend_abs};
                        res_valid <= 1;
                    end else begin
                        // Initialize accumulator
                        acc <= {1'b0, {WIDTH{1'b0}}, dividend_abs};
                        cnt <= 0;
                        state <= CALC;
                    end
                end
            end
            
            CALC: begin
                if (cnt == ITERATIONS) begin
                    // Final iteration - correct negative remainder
                    if (acc[2*WIDTH]) begin
                        acc[2*WIDTH:WIDTH+1] <= acc[2*WIDTH:WIDTH+1] + divisor_abs;
                    end
                    
                    // Apply sign correction if signed operation
                    if (sign) begin
                        result[WIDTH-1:0] <= q_sign ? -acc[WIDTH:1] : acc[WIDTH:1];
                        result[2*WIDTH-1:WIDTH] <= r_sign ? -acc[2*WIDTH:WIDTH+1] : acc[2*WIDTH:WIDTH+1];
                    end else begin
                        result <= acc[2*WIDTH:1];
                    end
                    
                    res_valid <= 1;
                    state <= IDLE;
                end else begin
                    // Non-restoring division step
                    if (acc[2*WIDTH]) begin
                        // Remainder was negative - add
                        acc <= {1'b0, (acc[2*WIDTH-1:0] << 1) + {divisor_abs, {WIDTH{1'b0}}}};
                    end else begin
                        // Remainder was positive - subtract
                        acc <= {1'b0, (acc[2*WIDTH-1:0] << 1) + {~divisor_abs + 1'b1, {WIDTH{1'b0}}}};
                    end
                    cnt <= cnt + 1;
                end
            end
        endcase
    end
end

endmodule