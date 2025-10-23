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

// Pipeline registers
reg [7:0] abs_dividend, abs_divisor;
reg div_by_zero;
reg [1:0] signs;
reg stage1_valid;

// Division registers
reg [2:0] cnt;
reg [15:0] partial;
reg [7:0] neg_divisor;
reg stage2_valid;

// Combinational signals
wire [7:0] dividend_abs = sign & dividend[7] ? -dividend : dividend;
wire [7:0] divisor_abs = sign & divisor[7] ? -divisor : divisor;
wire [8:0] sub_result = {1'b0, partial[15:8]} + {1'b0, neg_divisor};
wire sub_ok = ~sub_result[8];  // Positive result means partial >= divisor

always @(posedge clk or posedge rst) begin
    if (rst) begin
        // Reset all registers
        abs_dividend <= 0;
        abs_divisor <= 0;
        div_by_zero <= 0;
        signs <= 0;
        stage1_valid <= 0;
        cnt <= 0;
        partial <= 0;
        neg_divisor <= 0;
        stage2_valid <= 0;
        res_valid <= 0;
        result <= 0;
    end else begin
        // Pipeline Stage 1: Input processing and sign handling
        if (opn_valid) begin
            abs_dividend <= dividend_abs;
            abs_divisor <= divisor_abs;
            div_by_zero <= (divisor == 0);
            signs <= {sign & dividend[7], sign & divisor[7]};
            stage1_valid <= 1;
        end else begin
            stage1_valid <= 0;
        end

        // Pipeline Stage 2: Core division logic
        if (stage1_valid) begin
            if (div_by_zero) begin
                // Handle division by zero
                result <= 16'hFFFF;
                res_valid <= 1;
                stage2_valid <= 0;
            end else if (cnt == 0) begin
                // Initialize division
                partial <= {8'b0, abs_dividend} << 1;
                neg_divisor <= -abs_divisor;
                cnt <= 1;
                stage2_valid <= 1;
            end
        end

        if (stage2_valid) begin
            if (cnt < 8) begin
                // Perform one division step
                if (sub_ok) begin
                    partial <= {sub_result[7:0], partial[7:1], 1'b1};
                end else begin
                    partial <= {partial[15:1], 1'b0};
                end
                cnt <= cnt + 1;
            end else begin
                // Finalize result with sign correction
                if (signs[1] ^ signs[0]) begin
                    result[7:0] <= -partial[7:0];  // Quotient sign
                end else begin
                    result[7:0] <= partial[7:0];
                end
                
                if (signs[1]) begin
                    result[15:8] <= -partial[15:8];  // Remainder sign
                end else begin
                    result[15:8] <= partial[15:8];
                end
                
                res_valid <= 1;
                stage2_valid <= 0;
                cnt <= 0;
            end
        end else if (!opn_valid) begin
            res_valid <= 0;
        end
    end
end

endmodule