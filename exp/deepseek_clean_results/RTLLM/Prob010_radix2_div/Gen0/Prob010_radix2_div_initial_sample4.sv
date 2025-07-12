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

reg [7:0] dividend_reg;
reg [7:0] divisor_reg;
reg sign_reg;
reg [15:0] SR;       // Shift register: [remainder|quotient]
reg [7:0] NEG_DIVISOR;
reg [3:0] cnt;
reg start_cnt;
wire [8:0] sub_result;
wire carry_out;

// Subtraction result
assign sub_result = SR[15:8] + NEG_DIVISOR;
assign carry_out = sub_result[8];  // 1 means no borrow (SR >= divisor)

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
        result <= 0;
        cnt <= 0;
        start_cnt <= 0;
        SR <= 0;
    end else begin
        // Operation start
        if (opn_valid && !res_valid && !start_cnt) begin
            dividend_reg <= sign ? (dividend[7] ? -dividend : dividend) : dividend;
            divisor_reg <= sign ? (divisor[7] ? -divisor : divisor) : divisor;
            sign_reg <= sign;
            SR <= {8'b0, (sign ? (dividend[7] ? -dividend : dividend) : dividend), 1'b0};
            NEG_DIVISOR <= -(sign ? (divisor[7] ? -divisor : divisor) : divisor);
            cnt <= 1;
            start_cnt <= 1;
            res_valid <= 0;
        end

        // Division process
        if (start_cnt) begin
            if (cnt[3]) begin  // cnt == 8
                // Final result processing
                if (sign_reg) begin
                    // Correct signs for quotient and remainder
                    SR[15:8] <= (dividend[7] ^ divisor[7]) ? -SR[15:8] : SR[15:8];
                    SR[7:0] <= (dividend[7] ^ divisor[7]) ? -SR[7:0] : SR[7:0];
                end
                result <= {SR[15:8], SR[7:0]};
                res_valid <= 1;
                start_cnt <= 0;
                cnt <= 0;
            end else begin
                // Perform subtraction and shift
                if (carry_out) begin
                    SR <= {sub_result[7:0], SR[7:1], 1'b1};
                end else begin
                    SR <= {SR[14:0], 1'b0};
                end
                cnt <= cnt + 1;
            end
        end

        // Clear valid when result is read
        if (res_valid && opn_valid) begin
            res_valid <= 0;
        end
    end
end

endmodule