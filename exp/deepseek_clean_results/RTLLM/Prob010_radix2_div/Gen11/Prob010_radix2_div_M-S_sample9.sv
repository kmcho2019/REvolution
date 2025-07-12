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

reg [2:0] cnt;        // 0-7 counter
reg [15:0] acc;       // Accumulator: {remainder, quotient}
reg [7:0] divisor_abs;
reg dividend_neg, divisor_neg;
reg calculating;

// Absolute values
wire [7:0] dividend_abs = sign & dividend[7] ? -dividend : dividend;
wire [7:0] divisor_abs_val = sign & divisor[7] ? -divisor : divisor;

// Non-restoring division step
wire [8:0] sub_result = {acc[15:8], 1'b0} + {1'b0, ~divisor_abs + 1'b1};
wire carry_out = ~sub_result[8];  // 1 if result positive
wire [15:0] next_acc = carry_out ? 
    {sub_result[7:0], acc[7:0], 1'b1} : 
    {acc[14:0], 1'b0};

always @(posedge clk or posedge rst) begin
    if (rst) begin
        cnt <= 0;
        acc <= 0;
        res_valid <= 0;
        result <= 0;
        calculating <= 0;
    end else begin
        if (!calculating) begin
            res_valid <= 0;
            if (opn_valid && !res_valid) begin
                // Store signs and absolute values
                dividend_neg <= sign & dividend[7];
                divisor_neg <= sign & divisor[7];
                divisor_abs <= divisor_abs_val;
                
                // Initialize accumulator
                acc <= {8'b0, dividend_abs};
                cnt <= 0;
                calculating <= 1;
            end
        end else begin
            if (cnt == 3'd7) begin
                // Final iteration
                acc <= next_acc;
                
                // Final adjustment for non-restoring
                if (acc[15]) begin
                    acc[15:8] <= acc[15:8] + divisor_abs;
                end
                
                // Apply signs to result
                result <= {
                    dividend_neg ? -acc[15:8] : acc[15:8],  // remainder
                    (dividend_neg ^ divisor_neg) ? -acc[7:0] : acc[7:0]  // quotient
                };
                
                res_valid <= 1;
                calculating <= 0;
            end else begin
                // Normal iteration
                acc <= next_acc;
                cnt <= cnt + 1;
            end
        end
    end
end

endmodule