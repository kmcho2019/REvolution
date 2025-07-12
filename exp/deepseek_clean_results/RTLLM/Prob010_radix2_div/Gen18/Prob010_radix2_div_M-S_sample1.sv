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
reg [15:0] SR; // {remainder, quotient}
reg [7:0] divisor_reg;
reg [7:0] neg_divisor;
reg sign_q, sign_r;

wire [7:0] dividend_abs = sign & dividend[7] ? -dividend : dividend;
wire [7:0] divisor_abs = sign & divisor[7] ? -divisor : divisor;
wire [8:0] sub_result = {SR[15:8], 1'b0} + {1'b0, neg_divisor};

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
        result <= 0;
        cnt <= 0;
        SR <= 0;
    end else begin
        if (opn_valid && !res_valid) begin
            // Initialize operation
            sign_q <= sign & (dividend[7] ^ divisor[7]);
            sign_r <= sign & dividend[7];
            divisor_reg <= divisor_abs;
            neg_divisor <= ~divisor_abs + 1;
            SR <= {8'b0, dividend_abs};
            cnt <= 1;
            res_valid <= 0;
        end else if (cnt > 0 && cnt < 9) begin
            // Division steps
            if (sub_result[8]) begin
                SR <= {SR[14:0], 1'b0}; // Shift left, LSB=0
            end else begin
                SR <= {sub_result[7:0], SR[7:0], 1'b1}; // Shift left, LSB=1
            end
            cnt <= cnt + 1;
        end else if (cnt == 9) begin
            // Final remainder adjustment
            if (SR[15]) begin
                SR[15:8] <= SR[15:8] + divisor_reg;
            end
            // Apply signs if needed
            result[7:0] <= sign_q ? -SR[7:0] : SR[7:0];
            result[15:8] <= sign_r ? -SR[15:8] : SR[15:8];
            res_valid <= 1;
            cnt <= 0;
        end else if (divisor == 0) begin
            // Handle division by zero
            result <= {dividend, 8'hFF};
            res_valid <= 1;
        end
    end
end

endmodule