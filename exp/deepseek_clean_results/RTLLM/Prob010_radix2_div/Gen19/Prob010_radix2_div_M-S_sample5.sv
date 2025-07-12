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
reg calculating;

// Absolute values
wire [7:0] abs_dividend = sign & dividend[7] ? -dividend : dividend;
wire [7:0] abs_divisor = sign & divisor[7] ? -divisor : divisor;

// Subtraction result
wire [8:0] sub_res = {1'b0, sr[15:8]} - {1'b0, divisor_abs};

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
        calculating <= 0;
        cnt <= 0;
        sr <= 0;
    end else begin
        if (calculating) begin
            if (cnt == 8) begin
                // Final remainder correction if negative
                if (sr[15]) begin
                    sr[15:8] <= sr[15:8] + divisor_abs;
                end
                
                // Apply signs and output result
                result[15:8] <= r_sign ? -sr[15:8] : sr[15:8];  // remainder
                result[7:0] <= q_sign ? -sr[7:0] : sr[7:0];     // quotient
                res_valid <= 1;
                calculating <= 0;
            end else begin
                // Non-restoring division step
                sr <= sub_res[8] ? 
                    {sr[14:0], 1'b0} :         // negative result
                    {sub_res[7:0], sr[6:0], 1'b1}; // positive result
                cnt <= cnt + 1;
            end
        end else if (opn_valid && !res_valid) begin
            // Initialize new division
            calculating <= 1;
            res_valid <= 0;
            cnt <= 0;
            
            // Calculate signs
            q_sign <= sign & (dividend[7] ^ divisor[7]);
            r_sign <= sign & dividend[7];
            
            // Store absolute divisor and initialize shift register
            divisor_abs <= abs_divisor;
            sr <= {8'b0, abs_dividend};
        end else begin
            res_valid <= 0;
        end
    end
end

endmodule