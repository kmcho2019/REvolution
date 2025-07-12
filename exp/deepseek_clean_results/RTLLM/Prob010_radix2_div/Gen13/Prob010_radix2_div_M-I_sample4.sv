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

reg [2:0] cnt;          // 0-7 counter (3 bits sufficient)
reg [15:0] acc;         // Accumulator: {remainder, quotient}
reg calc_active;
reg q_sign, r_sign;
reg div_by_zero;

// Precompute absolute values and signs
wire [7:0] abs_dividend = sign & dividend[7] ? -dividend : dividend;
wire [7:0] abs_divisor = sign & divisor[7] ? -divisor : divisor;
wire [7:0] neg_divisor = -abs_divisor;

// Division state machine
always @(posedge clk or posedge rst) begin
    if (rst) begin
        cnt <= 0;
        acc <= 0;
        res_valid <= 0;
        result <= 0;
        calc_active <= 0;
        div_by_zero <= 0;
    end else begin
        res_valid <= 0;
        
        if (calc_active) begin
            if (cnt == 3'd7) begin  // Final iteration
                // Final remainder adjustment for non-restoring division
                if (acc[15]) begin
                    acc[15:8] <= acc[15:8] + abs_divisor;
                end
                
                // Handle division by zero (quotient = max, remainder = dividend)
                if (div_by_zero) begin
                    result <= {dividend, 8'hFF};
                end else begin
                    // Apply signs to final result
                    result <= {
                        r_sign ? -acc[15:8] : acc[15:8],  // remainder
                        q_sign ? -acc[7:0] : acc[7:0]     // quotient
                    };
                end
                
                res_valid <= 1;
                calc_active <= 0;
            end else begin
                // Non-restoring division step
                if ({acc[15:8], 1'b0} + {1'b0, neg_divisor} >= 0) begin
                    acc <= {({acc[15:8], 1'b0} + {1'b0, neg_divisor})[7:0], acc[7:0], 1'b1};
                end else begin
                    acc <= {acc[14:0], 1'b0};
                end
                cnt <= cnt + 1;
            end
        end else if (opn_valid && !res_valid) begin
            // Check for division by zero
            div_by_zero <= (divisor == 0);
            
            // Store result signs
            r_sign <= sign & dividend[7];
            q_sign <= (sign & dividend[7]) ^ (sign & divisor[7]);
            
            // Initialize accumulator with absolute dividend
            acc <= {8'b0, abs_dividend};
            cnt <= 0;
            calc_active <= 1;
        end
    end
end

endmodule