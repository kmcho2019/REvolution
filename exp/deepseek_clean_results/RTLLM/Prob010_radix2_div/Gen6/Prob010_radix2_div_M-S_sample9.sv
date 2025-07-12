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

reg [15:0] SR;       // Shift register [remainder|quotient]
reg [7:0] NEG_DIV;    // Negative divisor
reg [2:0] cnt;       // 3-bit counter (0-7)
reg running;         // Division in progress
reg q_sign, r_sign;   // Result signs

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
        result <= 0;
        SR <= 0;
        cnt <= 0;
        running <= 0;
    end else begin
        res_valid <= 0;  // Default
        
        if (opn_valid && !running) begin
            // Start new division
            r_sign = sign & dividend[7];
            q_sign = sign & (dividend[7] ^ divisor[7]);
            
            if (divisor == 0) begin
                // Division by zero
                result <= {8'hFF, 8'hFF};
                res_valid <= 1;
            end else begin
                // Initialize division
                SR <= {(sign & dividend[7]) ? -dividend : dividend, 8'b0};
                NEG_DIV <= -((sign & divisor[7]) ? -divisor : divisor);
                cnt <= 0;
                running <= 1;
            end
        end else if (running) begin
            // Division steps
            if (cnt == 3'd7) begin
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