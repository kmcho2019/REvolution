module radix2_div #(
    parameter WIDTH = 8
) (
    input clk,
    input rst,
    input sign,
    input [WIDTH-1:0] dividend,
    input [WIDTH-1:0] divisor,
    input opn_valid,
    output reg res_valid,
    output reg [2*WIDTH-1:0] result
);

localparam MAX_VAL = {WIDTH{1'b1}};

reg [WIDTH-1:0] abs_dividend, abs_divisor;
reg dividend_neg, divisor_neg;
reg [3:0] cnt;
reg running;
reg div_by_zero, div_by_one;
reg result_sign;

wire [WIDTH-1:0] neg_divisor = -abs_divisor;
wire [WIDTH:0] sub_result = {1'b0, abs_dividend} + {1'b0, neg_divisor};
wire carry_out = sub_result[WIDTH];

// Power-of-two detection and shift amount calculation
wire is_power_of_two = (abs_divisor & (abs_divisor - 1)) == 0;
wire [WIDTH-1:0] pow2_mask = abs_divisor - 1;
wire [WIDTH-1:0] remainder = abs_dividend & pow2_mask;
wire [WIDTH-1:0] pow2_quotient = abs_dividend >> $clog2(abs_divisor);

// Pre-compute final result signs
wire final_quotient_sign = dividend_neg ^ divisor_neg;
wire final_remainder_sign = dividend_neg;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
        running <= 0;
        result <= 0;
        cnt <= 0;
    end else begin
        res_valid <= 0;

        if (opn_valid && !running) begin
            // Input processing and sign extraction
            dividend_neg <= sign & dividend[WIDTH-1];
            divisor_neg <= sign & divisor[WIDTH-1];
            abs_dividend <= (sign & dividend[WIDTH-1]) ? -dividend : dividend;
            abs_divisor <= (sign & divisor[WIDTH-1]) ? -divisor : divisor;
            
            // Special case detection
            div_by_zero <= (divisor == 0);
            div_by_one <= (abs_divisor == 1);
            result_sign <= dividend_neg ^ divisor_neg;
            
            if (divisor == 0) begin
                // Division by zero - return max values
                result <= {MAX_VAL, MAX_VAL};
                res_valid <= 1;
            end else if (abs_divisor == 1) begin
                // Division by ±1
                result <= {8'b0, result_sign ? -abs_dividend : abs_dividend};
                res_valid <= 1;
            end else if (is_power_of_two) begin
                // Power-of-two division
                result <= {final_remainder_sign ? -remainder : remainder,
                          result_sign ? -pow2_quotient : pow2_quotient};
                res_valid <= 1;
            end else begin
                // Start normal division
                cnt <= 1;
                running <= 1;
                result <= {abs_dividend, {WIDTH{1'b0}}};
            end
        end else if (running) begin
            // Non-restoring division iteration
            if (cnt <= WIDTH) begin
                if (result[2*WIDTH-1]) begin
                    // Negative remainder case
                    result[2*WIDTH-1:WIDTH] <= result[2*WIDTH-1:WIDTH] + abs_divisor;
                    result[WIDTH-1:0] <= {result[WIDTH-2:0], 1'b0};
                end else begin
                    // Positive remainder case
                    result[2*WIDTH-1:WIDTH] <= sub_result[WIDTH-1:0];
                    result[WIDTH-1:0] <= {result[WIDTH-2:0], ~carry_out};
                end
                
                if (cnt == WIDTH) begin
                    // Final correction and sign application
                    if (result[2*WIDTH-1]) begin
                        result[2*WIDTH-1:WIDTH] <= result[2*WIDTH-1:WIDTH] + abs_divisor;
                    end
                    
                    result[2*WIDTH-1:WIDTH] <= final_remainder_sign ? 
                                              -result[2*WIDTH-1:WIDTH] : 
                                               result[2*WIDTH-1:WIDTH];
                    result[WIDTH-1:0] <= result_sign ? 
                                        -result[WIDTH-1:0] : 
                                         result[WIDTH-1:0];
                    
                    res_valid <= 1;
                    running <= 0;
                end
                cnt <= cnt + 1;
            end
        end
    end
end

endmodule