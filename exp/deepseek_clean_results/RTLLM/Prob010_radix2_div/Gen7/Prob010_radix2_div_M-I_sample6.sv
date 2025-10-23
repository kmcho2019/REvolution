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

reg [15:0] SR;        // Shift register [remainder|quotient]
reg [7:0] NEG_DIV;     // Negative divisor
reg [3:0] cnt;        // 4-bit counter (0-8)
reg running;          // Division in progress
reg q_sign, r_sign;    // Result signs
reg div_by_zero;      // Division by zero flag

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
        result <= 0;
        SR <= 0;
        cnt <= 0;
        running <= 0;
        div_by_zero <= 0;
    end else begin
        res_valid <= 0;  // Default
        
        if (opn_valid && !running) begin
            // Start new division
            div_by_zero <= (divisor == 0);
            
            if (sign) begin
                r_sign = dividend[7];
                q_sign = dividend[7] ^ divisor[7];
                SR <= {dividend[7] ? -dividend : dividend, 8'b0};
                NEG_DIV <= divisor[7] ? divisor : -divisor;
            end else begin
                r_sign = 0;
                q_sign = 0;
                SR <= {dividend, 8'b0};
                NEG_DIV <= -divisor;
            end
            
            cnt <= 0;
            running <= 1;
        end else if (running) begin
            // Division steps
            if (div_by_zero) begin
                // Handle division by zero
                result <= {8'hFF, 8'h00}; // Standard behavior
                res_valid <= 1;
                running <= 0;
            end else if (cnt == 4'd8) begin
                // Final step
                running <= 0;
                
                // Restore remainder if negative
                if (SR[15]) begin
                    SR[15:8] <= SR[15:8] - NEG_DIV;
                    SR[7:0] <= SR[7:0] - 1;
                end
                
                // Apply signs
                result[15:8] <= r_sign ? -SR[15:8] : SR[15:8];
                result[7:0] <= q_sign ? -SR[7:0] : SR[7:0];
                res_valid <= 1;
            end else begin
                // Division step
                if (SR[15:8] >= -NEG_DIV) begin
                    SR[15:8] <= SR[15:8] + NEG_DIV;
                    SR <= {SR[14:0], 1'b1};
                end else begin
                    SR <= {SR[14:0], 1'b0};
                end
                cnt <= cnt + 1;
            end
        end
    end
end

endmodule