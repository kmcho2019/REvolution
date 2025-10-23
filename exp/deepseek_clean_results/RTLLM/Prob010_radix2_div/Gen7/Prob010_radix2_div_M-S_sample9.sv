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

reg [2:0] cnt;       // 0-7 counter for 8 iterations
reg [15:0] SR;       // Shift register [remainder|quotient]
reg [7:0] divisor_abs;
reg calculating;
wire [7:0] dividend_abs = sign & dividend[7] ? -dividend : dividend;
wire [7:0] divisor_neg = -divisor_abs;
wire division_by_zero = (divisor_abs == 0);
wire [8:0] sub_result = {1'b0, SR[15:8]} + {1'b0, divisor_neg};

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
        result <= 0;
        calculating <= 0;
        cnt <= 0;
    end else begin
        if (calculating) begin
            // Perform division step
            if (sub_result[8]) begin  // If subtraction is positive
                SR <= {sub_result[7:0], SR[7:0], 1'b1};
            end else begin
                SR <= {SR[14:0], 1'b0};
            end

            if (cnt == 3'd7) begin  // After 8 iterations
                // Final remainder adjustment if needed
                if (SR[15]) begin
                    SR[15:8] <= SR[15:8] + divisor_abs;
                    SR[7:0] <= SR[7:0] - 1;
                end
                
                // Apply final signs
                result[15:8] <= sign & dividend[7] ? -SR[15:8] : SR[15:8];
                result[7:0] <= (sign & (dividend[7] ^ divisor[7])) ? -SR[7:0] : SR[7:0];
                res_valid <= 1;
                calculating <= 0;
            end else begin
                cnt <= cnt + 1;
            end
        end else if (opn_valid && !res_valid) begin
            // Start new division
            divisor_abs <= sign & divisor[7] ? -divisor : divisor;
            
            if (division_by_zero) begin
                result <= {8'hFF, 8'hFF};  // Error value
                res_valid <= 1;
            end else begin
                SR <= {dividend_abs, 8'b0};
                cnt <= 0;
                calculating <= 1;
                res_valid <= 0;
            end
        end else if (!opn_valid) begin
            res_valid <= 0;  // Ready for new operation
        end
    end
end

endmodule