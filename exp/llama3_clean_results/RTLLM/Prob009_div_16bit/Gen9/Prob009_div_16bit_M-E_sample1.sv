module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] stage1_quotient;
reg [15:0] stage1_remainder;
reg [15:0] stage2_quotient;
reg [15:0] stage2_remainder;
reg [15:0] stage3_quotient;
reg [15:0] stage3_remainder;
reg [15:0] stage4_quotient;
reg [15:0] stage4_remainder;

always @(*) begin
    stage1_quotient = 0;
    stage1_remainder = A[15:8];

    if (stage1_remainder >= B) begin
        stage1_quotient = 1;
        stage1_remainder = stage1_remainder - B;
    end
end

always @(*) begin
    stage2_quotient = stage1_quotient;
    stage2_remainder = {stage1_remainder, A[7:4]};

    if (stage2_remainder >= {8'd0, B}) begin
        stage2_quotient = stage2_quotient | (1 << 1);
        stage2_remainder = stage2_remainder - {8'd0, B};
    end
end

always @(*) begin
    stage3_quotient = stage2_quotient;
    stage3_remainder = {stage2_remainder, A[3:0]};

    if (stage3_remainder >= {8'd0, B}) begin
        stage3_quotient = stage3_quotient | (1 << 2);
        stage3_remainder = stage3_remainder - {8'd0, B};
    end
end

always @(*) begin
    stage4_quotient = stage3_quotient;
    result = stage4_quotient;
    odd = stage3_remainder;
end

endmodule