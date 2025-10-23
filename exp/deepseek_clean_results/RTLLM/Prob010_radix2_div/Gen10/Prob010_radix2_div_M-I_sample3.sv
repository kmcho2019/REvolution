module radix2_div (
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output reg res_valid,
    output reg error,
    output reg [15:0] result
);

reg [2:0] state;  // 0: idle, 1-7: calculating, 7: done
reg [15:0] SR;    // [remainder|quotient]
reg [7:0] divisor_abs;
reg [7:0] divisor_neg;
reg quotient_sign;
reg remainder_sign;

wire [7:0] dividend_abs = (sign & dividend[7]) ? -dividend : dividend;
wire [7:0] divisor_abs_pre = (sign & divisor[7]) ? -divisor : divisor;
wire [8:0] sub_result = {1'b0, SR[15:8]} + {1'b0, divisor_neg};

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= 0;
        SR <= 0;
        res_valid <= 0;
        error <= 0;
        result <= 0;
    end else begin
        if (opn_valid && (state == 0) && !res_valid) begin
            // Start new division
            if (divisor == 0) begin
                // Divide by zero
                state <= 0;
                res_valid <= 1;
                error <= 1;
                result <= {8'hFF, 8'hFF};
            end else if (divisor_abs_pre == 8'd1) begin
                // Early termination for divisor=1
                state <= 0;
                res_valid <= 1;
                error <= 0;
                result <= {8'b0, dividend};
            end else if (dividend_abs == 0) begin
                // Early termination for dividend=0
                state <= 0;
                res_valid <= 1;
                error <= 0;
                result <= 0;
            end else begin
                // Initialize division
                SR <= {8'b0, dividend_abs};
                divisor_abs <= divisor_abs_pre;
                divisor_neg <= -divisor_abs_pre;
                quotient_sign <= sign & (dividend[7] ^ divisor[7]);
                remainder_sign <= sign & dividend[7];
                state <= 1;
                res_valid <= 0;
                error <= 0;
            end
        end else if (state > 0 && state < 7) begin
            // Division step
            if (sub_result[8]) begin  // if remainder >= divisor
                SR <= {sub_result[7:0], SR[7:0], 1'b1};
            end else begin
                SR <= {SR[14:0], 1'b0};
            end
            state <= state + 1;
        end else if (state == 7) begin
            // Final step and result preparation
            state <= 0;
            res_valid <= 1;
            error <= 0;
            // Apply sign correction
            result <= {
                remainder_sign ? -SR[15:8] : SR[15:8],
                quotient_sign ? -SR[7:0] : SR[7:0]
            };
        end else if (res_valid && opn_valid) begin
            // Ready for new operation
            res_valid <= 0;
        end
    end
end

endmodule