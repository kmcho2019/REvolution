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
reg [15:0] stage1_quotient;

reg [15:0] stage2_remainder;
reg [15:0] stage2_quotient;

always @(*) begin
    dividend = A;
    divisor = B;
    quotient = 0;
    remainder = 0;

    // Stage 1: Extract bits and compare
    stage1_remainder = {dividend[15:8], 8'd0};
    stage1_quotient = (stage1_remainder >= {8'd0, divisor}) ? 1 : 0;

    // Stage 2: Subtract and update remainder
    if (stage1_quotient) begin
        stage2_remainder = stage1_remainder - {8'd0, divisor};
    end else begin
        stage2_remainder = stage1_remainder;
    end

    // Stage 3: Update quotient and remainder
    quotient = {stage1_quotient, 15'd0};
    remainder = stage2_remainder;

    // Repeat for remaining bits
    for (int i = 7; i >= 0; i--) begin
        remainder = {remainder[7:0], dividend[i]};
        if (remainder >= {8'd0, divisor}) begin
            quotient = quotient | (1 << i);
            remainder = remainder - {8'd0, divisor};
        end
    end

    result = quotient;
    odd = {8'd0, remainder[7:0]};
end

endmodule