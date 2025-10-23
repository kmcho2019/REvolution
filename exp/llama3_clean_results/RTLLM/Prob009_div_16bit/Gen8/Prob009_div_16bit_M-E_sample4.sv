module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] temp_quotient;
reg [15:0] temp_remainder;

// Stage 1: Compare high 8 bits of dividend with divisor
wire [7:0] stage1_quotient;
wire [7:0] stage1_remainder;
div_stage stage1(
    .A(A[15:8]),
    .B(B),
    .quotient(stage1_quotient),
    .remainder(stage1_remainder)
);

// Stage 2: Compare next 4 bits of dividend with remainder
wire [3:0] stage2_quotient;
wire [7:0] stage2_remainder;
div_stage stage2(
    .A({stage1_remainder, A[7:4]}),
    .B(B),
    .quotient(stage2_quotient),
    .remainder(stage2_remainder)
);

// Stage 3: Compare next 4 bits of dividend with remainder
wire [3:0] stage3_quotient;
wire [7:0] stage3_remainder;
div_stage stage3(
    .A({stage2_remainder, A[3:0]}),
    .B(B),
    .quotient(stage3_quotient),
    .remainder(stage3_remainder)
);

// Combine quotient bits
assign temp_quotient = {stage1_quotient, stage2_quotient, stage3_quotient};

// Assign remainder
assign temp_remainder = {8'd0, stage3_remainder};

// Assign outputs
always @(*) begin
    result = temp_quotient;
    odd = temp_remainder;
end

endmodule

module div_stage(
    input [7:0] A,
    input [7:0] B,
    output reg [3:0] quotient,
    output reg [7:0] remainder
);

always @(*) begin
    if (A >= B) begin
        quotient = 4'b1;
        remainder = A - B;
    end else begin
        quotient = 4'b0;
        remainder = A;
    end
end

endmodule