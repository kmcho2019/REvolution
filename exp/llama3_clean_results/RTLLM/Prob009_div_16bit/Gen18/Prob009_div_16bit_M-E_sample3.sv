module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] dividend;
reg [7:0] divisor;
reg [15:0] quotient;
reg [15:0] remainder;

reg [15:0] stage1_remainder;
reg [15:0] stage2_remainder;
reg [15:0] stage3_remainder;
reg [15:0] stage4_remainder;

reg [15:0] stage1_quotient;
reg [15:0] stage2_quotient;
reg [15:0] stage3_quotient;
reg [15:0] stage4_quotient;

always @(*) begin
    dividend = A;
    divisor = B;
    quotient = 0;
    remainder = 0;

    // Stage 1: Process bits 15:12
    stage1_remainder = {dividend[15:12], 4'd0};
    stage1_quotient = 0;
    if (stage1_remainder >= {8'd0, divisor}) begin
        stage1_quotient = 1;
        stage1_remainder = stage1_remainder - {8'd0, divisor};
    end

    // Stage 2: Process bits 11:8
    stage2_remainder = {stage1_remainder[7:0], dividend[11:8]};
    stage2_quotient = stage1_quotient;
    if (stage2_remainder >= {8'd0, divisor}) begin
        stage2_quotient = stage2_quotient | (1 << 8);
        stage2_remainder = stage2_remainder - {8'd0, divisor};
    end

    // Stage 3: Process bits 7:4
    stage3_remainder = {stage2_remainder[7:0], dividend[7:4]};
    stage3_quotient = stage2_quotient;
    if (stage3_remainder >= {8'd0, divisor}) begin
        stage3_quotient = stage3_quotient | (1 << 4);
        stage3_remainder = stage3_remainder - {8'd0, divisor};
    end

    // Stage 4: Process bits 3:0
    stage4_remainder = {stage3_remainder[7:0], dividend[3:0]};
    stage4_quotient = stage3_quotient;
    if (stage4_remainder >= {8'd0, divisor}) begin
        stage4_quotient = stage4_quotient | (1 << 0);
        stage4_remainder = stage4_remainder - {8'd0, divisor};
    end

    result = stage4_quotient;
    odd = {8'd0, stage4_remainder[7:0]};
end

endmodule