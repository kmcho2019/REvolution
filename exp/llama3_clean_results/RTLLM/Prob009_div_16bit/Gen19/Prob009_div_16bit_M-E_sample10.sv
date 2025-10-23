module div_16bit(
    input clk,
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] quotient;
reg [15:0] remainder;
reg [7:0] b_reg;

always @(*) begin
    b_reg = B;
end

// Pipeline Stage 1
reg [15:0] stage1_quotient;
reg [15:0] stage1_remainder;

always @(posedge clk) begin
    if (A[15:8] >= b_reg) begin
        stage1_quotient = 1;
        stage1_remainder = A[15:8] - b_reg;
    end else begin
        stage1_quotient = 0;
        stage1_remainder = A[15:8];
    end
end

// Pipeline Stage 2
reg [15:0] stage2_quotient;
reg [15:0] stage2_remainder;

always @(posedge clk) begin
    if ({stage1_remainder[7:0], A[7:0]} >= {8'd0, b_reg}) begin
        stage2_quotient = {stage1_quotient, 1};
        stage2_remainder = {stage1_remainder[7:0], A[7:0]} - {8'd0, b_reg};
    end else begin
        stage2_quotient = {stage1_quotient, 0};
        stage2_remainder = {stage1_remainder[7:0], A[7:0]};
    end
end

// Final Stage
always @(posedge clk) begin
    result <= stage2_quotient;
    odd <= {8'd0, stage2_remainder[7:0]};
end

endmodule