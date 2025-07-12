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
reg dividend_neg, divisor_neg;
reg [3:0] cnt;
reg running;
reg div_by_zero, div_by_one;

wire [7:0] neg_divisor = -abs_divisor;
wire [8:0] sub_result = {1'b0, abs_dividend} + {1'b0, neg_divisor};
wire carry_out = sub_result[8];

// Power-of-two detection
wire is_power_of_two = (abs_divisor & (abs_divisor - 1)) == 0;
wire [2:0] shift_amount;
priority_encoder pe (.in(abs_divisor), .out(shift_amount));

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
        running <= 0;
        result <= 0;
    end else begin
        res_valid <= 0;

        if (opn_valid && !running) begin
            // Input processing
            dividend_neg <= sign & dividend[7];
            divisor_neg <= sign & divisor[7];
            abs_dividend <= (sign & dividend[7]) ? -dividend : dividend;
            abs_divisor <= (sign & divisor[7]) ? -divisor : divisor;
            
            // Special case detection
            div_by_zero <= (divisor == 0);
            div_by_one <= (abs_divisor == 8'd1);
            
            if (divisor == 0) begin
                // Division by zero
                result <= {8'hFF, 8'hFF};
                res_valid <= 1;
            end else if (abs_divisor == 8'd1) begin
                // Division by ±1
                result <= {8'b0, (dividend_neg ^ divisor_neg) ? -abs_dividend : abs_dividend};
                res_valid <= 1;
            end else if (is_power_of_two) begin
                // Power-of-two division
                result <= {(abs_dividend % abs_divisor), 
                           ((dividend_neg ^ divisor_neg) ? -abs_dividend : abs_dividend) >> shift_amount};
                res_valid <= 1;
            end else begin
                // Start normal division
                cnt <= 0;
                running <= 1;
            end
        end else if (running) begin
            // Non-restoring division iteration
            if (carry_out) begin
                abs_dividend <= sub_result[7:0];
                result[7:0] <= {result[6:0], 1'b1};
            end else begin
                result[7:0] <= {result[6:0], 1'b0};
            end

            if (cnt == 8) begin
                // Final correction
                if (abs_dividend[7]) begin
                    abs_dividend <= abs_dividend + abs_divisor;
                    result[7:0] <= result[7:0] - 1;
                end
                
                // Apply signs
                result[15:8] <= dividend_neg ? -abs_dividend : abs_dividend;
                result[7:0] <= (dividend_neg ^ divisor_neg) ? -result[7:0] : result[7:0];
                
                res_valid <= 1;
                running <= 0;
            end
            cnt <= cnt + 1;
        end
    end
end

// Priority encoder for power-of-two shift amount
module priority_encoder (
    input [7:0] in,
    output reg [2:0] out
);
always @* begin
    casez (in)
        8'b???????1: out = 0;
        8'b??????10: out = 1;
        8'b?????100: out = 2;
        8'b????1000: out = 3;
        8'b???10000: out = 4;
        8'b??100000: out = 5;
        8'b?1000000: out = 6;
        8'b10000000: out = 7;
        default: out = 0;
    endcase
end
endmodule

endmodule