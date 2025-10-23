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

// Pipeline registers
reg [7:0] abs_dividend_p1, abs_divisor_p1;
reg dividend_neg_p1, divisor_neg_p1;
reg [7:0] quotient_p1;
reg [7:0] partial_rem_p1;
reg running_p1;
reg special_case_p1;

// Special case detection
wire div_by_zero = (divisor == 0);
wire div_by_one = (divisor == 1) || (divisor == 8'hFF);
wire is_power_of_two;
wire [2:0] shift_amount;

// Power-of-two detection
assign is_power_of_two = (divisor & (divisor - 1)) == 0;
assign shift_amount = divisor[0] ? 0 :
                      divisor[1] ? 1 :
                      divisor[2] ? 2 :
                      divisor[3] ? 3 :
                      divisor[4] ? 4 :
                      divisor[5] ? 5 :
                      divisor[6] ? 6 : 7;

// Division state machine
reg [3:0] cnt;
reg running;
wire division_done = (cnt == 8);

// Arithmetic signals
wire [8:0] sub_result = {partial_rem_p1, quotient_p1[7]} + {1'b0, abs_divisor_p1};
wire [8:0] add_result = {partial_rem_p1, quotient_p1[7]} + {1'b0, ~abs_divisor_p1 + 1'b1};
wire carry_out = sub_result[8];

always @(posedge clk or posedge rst) begin
    if (rst) begin
        // Reset all pipeline registers
        abs_dividend_p1 <= 0;
        abs_divisor_p1 <= 0;
        dividend_neg_p1 <= 0;
        divisor_neg_p1 <= 0;
        quotient_p1 <= 0;
        partial_rem_p1 <= 0;
        running_p1 <= 0;
        special_case_p1 <= 0;
        res_valid <= 0;
        result <= 0;
        cnt <= 0;
        running <= 0;
    end else begin
        // Default outputs
        res_valid <= 0;

        // Pipeline Stage 1: Input Processing
        if (opn_valid && !running) begin
            // Calculate absolute values
            abs_dividend_p1 <= (sign & dividend[7]) ? -dividend : dividend;
            abs_divisor_p1 <= (sign & divisor[7]) ? -divisor : divisor;
            
            // Store sign information
            dividend_neg_p1 <= sign & dividend[7];
            divisor_neg_p1 <= sign & divisor[7];
            
            // Initialize division registers
            quotient_p1 <= 0;
            partial_rem_p1 <= 0;
            
            // Check for special cases
            if (div_by_zero) begin
                special_case_p1 <= 1;
                result <= {8'hFF, 8'hFF}; // Division by zero result
                res_valid <= 1;
            end else if (div_by_one) begin
                special_case_p1 <= 1;
                result <= {8'b0, (dividend_neg_p1 ^ divisor_neg_p1) ? -abs_dividend_p1 : abs_dividend_p1};
                res_valid <= 1;
            end else if (is_power_of_two) begin
                special_case_p1 <= 1;
                result <= {(abs_dividend_p1 & (abs_divisor_p1 - 1)), 
                           (abs_dividend_p1 >> shift_amount)};
                res_valid <= 1;
            end else begin
                special_case_p1 <= 0;
                running_p1 <= 1;
                running <= 1;
                cnt <= 0;
            end
        end

        // Pipeline Stage 2: Division Core
        if (running_p1) begin
            if (!division_done) begin
                // Non-restoring division step
                if (partial_rem_p1[7]) begin
                    // Add when remainder is negative
                    {partial_rem_p1, quotient_p1} <= {add_result[7:0], quotient_p1[6:0], ~add_result[8]};
                end else begin
                    // Subtract when remainder is positive
                    {partial_rem_p1, quotient_p1} <= {sub_result[7:0], quotient_p1[6:0], sub_result[8]};
                end
                cnt <= cnt + 1;
            end else begin
                // Final correction step
                if (partial_rem_p1[7]) begin
                    partial_rem_p1 <= partial_rem_p1 + abs_divisor_p1;
                    quotient_p1 <= quotient_p1 - 1;
                end
                
                // Apply signs to results
                result[15:8] <= dividend_neg_p1 ? -partial_rem_p1 : partial_rem_p1;
                result[7:0] <= (dividend_neg_p1 ^ divisor_neg_p1) ? -quotient_p1 : quotient_p1;
                
                res_valid <= 1;
                running_p1 <= 0;
                running <= 0;
            end
        end
    end
end

endmodule