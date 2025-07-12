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

reg [2:0] cnt;  // Reduced from 4 bits since we only count to 8
reg [15:0] sr;   // {remainder, quotient}
reg calculating;

// Absolute values and signs computed combinatorially
wire [7:0] abs_dividend = sign & dividend[7] ? -dividend : dividend;
wire [7:0] abs_divisor = sign & divisor[7] ? -divisor : divisor;
wire q_sign = sign & (dividend[7] ^ divisor[7]);
wire r_sign = sign & dividend[7];

// Subtraction result
wire [8:0] sub_res = {1'b0, sr[15:8]} - {1'b0, abs_divisor};

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
        calculating <= 0;
        cnt <= 0;
        sr <= 0;
    end else begin
        res_valid <= 0;  // Default value
        
        if (calculating) begin
            if (cnt == 3'd7) begin  // Final iteration
                // Correct negative remainder
                if (sr[15]) sr[15:8] <= sr[15:8] + abs_divisor;
                
                // Apply signs and output
                result[15:8] <= r_sign ? -sr[15:8] : sr[15:8];
                result[7:0] <= q_sign ? -sr[7:0] : sr[7:0];
                res_valid <= 1;
                calculating <= 0;
            end else begin
                // Division step
                sr <= sub_res[8] ? 
                    {sr[14:0], 1'b0} :         // Negative result
                    {sub_res[7:0], sr[6:0], 1'b1}; // Positive result
                cnt <= cnt + 1;
            end
        end else if (opn_valid) begin
            // Start new division
            calculating <= 1;
            cnt <= 0;
            sr <= {8'b0, abs_dividend};  // Initialize shift register
        end
    end
end

endmodule