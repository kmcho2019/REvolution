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

reg [3:0] cnt;
reg [15:0] sr;  // {remainder, quotient}
reg [7:0] divisor_abs;
reg q_sign, r_sign;
reg zero_divisor;

// Absolute values and sign computation
wire [7:0] abs_dividend = sign & dividend[7] ? -dividend : dividend;
wire [7:0] abs_divisor = sign & divisor[7] ? -divisor : divisor;

// Pre-compute subtraction result
wire [8:0] sub_res = {1'b0, sr[15:8]} + {1'b0, ~divisor_abs} + 1'b1;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
        cnt <= 0;
        sr <= 0;
        zero_divisor <= 0;
    end else begin
        res_valid <= 0;  // Default
        
        if (cnt == 0) begin
            // Idle state
            if (opn_valid && !res_valid) begin
                // Check for zero divisor
                zero_divisor <= (divisor == 0);
                
                if (divisor == 0) begin
                    // Handle division by zero
                    result <= {8'hFF, 8'hFF};  // Error pattern
                    res_valid <= 1;
                end else begin
                    // Initialize division
                    cnt <= 1;
                    q_sign <= sign & (dividend[7] ^ divisor[7]);
                    r_sign <= sign & dividend[7];
                    divisor_abs <= abs_divisor;
                    sr <= {8'b0, abs_dividend};
                end
            end
        end else if (cnt <= 8) begin
            // Division in progress
            if (cnt == 8) begin
                // Final remainder correction if negative
                if (sr[15]) begin
                    sr[15:8] <= sr[15:8] + divisor_abs;
                end
                
                // Apply signs and output result
                result[15:8] <= r_sign ? -sr[15:8] : sr[15:8];  // remainder
                result[7:0] <= q_sign ? -sr[7:0] : sr[7:0];     // quotient
                res_valid <= 1;
                cnt <= 0;
            end else begin
                // Non-restoring division step
                sr <= sub_res[8] ? 
                    {sr[14:0], 1'b0} :         // negative result
                    {sub_res[7:0], sr[6:0], 1'b1}; // positive result
                cnt <= cnt + 1;
            end
        end
    end
end

endmodule