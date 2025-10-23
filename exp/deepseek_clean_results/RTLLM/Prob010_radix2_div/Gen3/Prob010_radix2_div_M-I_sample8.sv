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

// Internal registers
reg [1:0] state;  // 0: IDLE, 1: CALC
reg [WIDTH-1:0] dividend_abs;
reg [WIDTH-1:0] divisor_abs;
reg [2*WIDTH-1:0] acc;  // {remainder, quotient}
reg [3:0] cnt;
reg q_sign, r_sign;
reg special_case;

// Datapath signals
wire [WIDTH:0] sub_result = {1'b0, acc[2*WIDTH-1:WIDTH]} + {1'b1, ~divisor_abs + 1'b1};
wire borrow = ~sub_result[WIDTH];

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= 0;
        res_valid <= 0;
        result <= 0;
        acc <= 0;
        cnt <= 0;
        q_sign <= 0;
        r_sign <= 0;
        special_case <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                res_valid <= 0;
                if (opn_valid) begin
                    // Sign handling and absolute value calculation
                    q_sign <= sign & (dividend[WIDTH-1] ^ divisor[WIDTH-1]);
                    r_sign <= sign & dividend[WIDTH-1];
                    dividend_abs <= (sign & dividend[WIDTH-1]) ? -dividend : dividend;
                    divisor_abs <= (sign & divisor[WIDTH-1]) ? -divisor : divisor;
                    
                    // Special case detection
                    if (divisor_abs == 0) begin
                        acc <= {8'b0, {WIDTH{1'b1}}}; // Divide by zero = max quotient
                        special_case <= 1;
                        res_valid <= 1;
                        result <= acc;
                    end else if (divisor_abs == 1) begin
                        acc <= {8'b0, dividend_abs}; // Divide by one = dividend
                        special_case <= 1;
                        res_valid <= 1;
                        result <= acc;
                    end else begin
                        acc <= {8'b0, dividend_abs};
                        cnt <= 0;
                        special_case <= 0;
                        state <= 1;
                    end
                end
            end
            
            1: begin // CALC
                if (cnt == ITERATIONS) begin
                    // Final iteration - correct negative remainder
                    if (acc[2*WIDTH-1]) begin
                        acc[2*WIDTH-1:WIDTH] <= acc[2*WIDTH-1:WIDTH] + divisor_abs;
                    end
                    
                    // Apply sign correction if signed operation
                    if (sign) begin
                        acc[WIDTH-1:0] <= q_sign ? -acc[WIDTH-1:0] : acc[WIDTH-1:0];
                        acc[2*WIDTH-1:WIDTH] <= r_sign ? -acc[2*WIDTH-1:WIDTH] : acc[2*WIDTH-1:WIDTH];
                    end
                    
                    res_valid <= 1;
                    result <= acc;
                    state <= 0;
                end else begin
                    // Non-restoring division step
                    if (acc[2*WIDTH-1]) begin
                        // Remainder was negative - add
                        acc <= {acc[2*WIDTH-2:0], 1'b0} + {divisor_abs, {WIDTH{1'b0}}};
                    end else begin
                        // Remainder was positive - subtract
                        acc <= {acc[2*WIDTH-2:0], 1'b0} + {~divisor_abs + 1'b1, {WIDTH{1'b0}}};
                    end
                    cnt <= cnt + 1;
                end
            end
        endcase
    end
end

endmodule