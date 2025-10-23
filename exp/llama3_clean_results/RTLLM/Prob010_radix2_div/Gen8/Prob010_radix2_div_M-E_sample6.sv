module radix2_div(
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output reg res_valid,
    output reg [15:0] result
);

reg [7:0] abs_dividend;  // absolute value of dividend
reg [7:0] abs_divisor;  // absolute value of divisor
reg sign_result;  // sign of result

reg [7:0] stage0_remainder;  // remainder after stage 0
reg [7:0] stage1_remainder;  // remainder after stage 1
reg [7:0] stage2_remainder;  // remainder after stage 2
reg [7:0] stage3_remainder;  // remainder after stage 3
reg [7:0] stage4_remainder;  // remainder after stage 4
reg [7:0] stage5_remainder;  // remainder after stage 5
reg [7:0] stage6_remainder;  // remainder after stage 6
reg [7:0] stage7_remainder;  // remainder after stage 7

reg [7:0] quotient;  // quotient

// Preprocessing stage
always @(posedge clk or posedge rst) begin
    if (rst) begin
        abs_dividend <= 0;
        abs_divisor <= 0;
        sign_result <= 0;
    end else if (opn_valid) begin
        abs_dividend <= (sign && dividend[7])? ~dividend + 1 : dividend;
        abs_divisor <= (sign && divisor[7])? ~divisor + 1 : divisor;
        sign_result <= sign && (dividend[7] ^ divisor[7]);
    end
end

// Pipeline stages
always @(posedge clk or posedge rst) begin
    if (rst) begin
        stage0_remainder <= 0;
        stage1_remainder <= 0;
        stage2_remainder <= 0;
        stage3_remainder <= 0;
        stage4_remainder <= 0;
        stage5_remainder <= 0;
        stage6_remainder <= 0;
        stage7_remainder <= 0;
    end else if (opn_valid) begin
        stage0_remainder <= {1'b0, abs_dividend};
        stage1_remainder <= (stage0_remainder[7:0] >= abs_divisor)? {stage0_remainder[7:0] - abs_divisor, 1'b1} : {stage0_remainder[7:0], 1'b0};
        stage2_remainder <= (stage1_remainder[7:0] >= abs_divisor)? {stage1_remainder[7:0] - abs_divisor, stage1_remainder[0] << 1} : {stage1_remainder[7:0] << 1, stage1_remainder[0]};
        stage3_remainder <= (stage2_remainder[7:0] >= abs_divisor)? {stage2_remainder[7:0] - abs_divisor, stage2_remainder[0] << 1} : {stage2_remainder[7:0] << 1, stage2_remainder[0]};
        stage4_remainder <= (stage3_remainder[7:0] >= abs_divisor)? {stage3_remainder[7:0] - abs_divisor, stage3_remainder[0] << 1} : {stage3_remainder[7:0] << 1, stage3_remainder[0]};
        stage5_remainder <= (stage4_remainder[7:0] >= abs_divisor)? {stage4_remainder[7:0] - abs_divisor, stage4_remainder[0] << 1} : {stage4_remainder[7:0] << 1, stage4_remainder[0]};
        stage6_remainder <= (stage5_remainder[7:0] >= abs_divisor)? {stage5_remainder[7:0] - abs_divisor, stage5_remainder[0] << 1} : {stage5_remainder[7:0] << 1, stage5_remainder[0]};
        stage7_remainder <= (stage6_remainder[7:0] >= abs_divisor)? {stage6_remainder[7:0] - abs_divisor, stage6_remainder[0] << 1} : {stage6_remainder[7:0] << 1, stage6_remainder[0]};
    end
end

// Quotient calculation
always @(posedge clk or posedge rst) begin
    if (rst) begin
        quotient <= 0;
    end else if (opn_valid) begin
        quotient <= {stage7_remainder[0], stage6_remainder[0], stage5_remainder[0], stage4_remainder[0], stage3_remainder[0], stage2_remainder[0], stage1_remainder[0], 1'b0};
    end
end

// Result generation
always @(posedge clk or posedge rst) begin
    if (rst) begin
        result <= 0;
        res_valid <= 0;
    end else if (opn_valid) begin
        result <= {stage7_remainder[7:0], quotient};
        res_valid <= 1;
    end else begin
        res_valid <= 0;
    end
end

endmodule