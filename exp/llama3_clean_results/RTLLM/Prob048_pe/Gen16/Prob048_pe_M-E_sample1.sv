module pe (
    input clk,  // Clock signal
    input rst,  // Reset signal
    input [31:0] a,  // Input operand A
    input [31:0] b,  // Input operand B
    output [31:0] c  // Accumulated result
);

// Segmentation of input operands
wire [7:0] a0 = a[7:0];
wire [7:0] a1 = a[15:8];
wire [7:0] a2 = a[23:16];
wire [7:0] a3 = a[31:24];

wire [7:0] b0 = b[7:0];
wire [7:0] b1 = b[15:8];
wire [7:0] b2 = b[23:16];
wire [7:0] b3 = b[31:24];

// Partial products from segment multiplications
wire [15:0] p00 = a0 * b0;
wire [15:0] p01 = a0 * b1;
wire [15:0] p02 = a0 * b2;
wire [15:0] p03 = a0 * b3;

wire [15:0] p10 = a1 * b0;
wire [15:0] p11 = a1 * b1;
wire [15:0] p12 = a1 * b2;
wire [15:0] p13 = a1 * b3;

wire [15:0] p20 = a2 * b0;
wire [15:0] p21 = a2 * b1;
wire [15:0] p22 = a2 * b2;
wire [15:0] p23 = a2 * b3;

wire [15:0] p30 = a3 * b0;
wire [15:0] p31 = a3 * b1;
wire [15:0] p32 = a3 * b2;
wire [15:0] p33 = a3 * b3;

// Pipelined accumulation
reg [31:0] stage1, stage2, stage3;
always @(posedge clk) begin
    if (rst) begin
        stage1 <= 32'd0;
        stage2 <= 32'd0;
        stage3 <= 32'd0;
    end else begin
        stage1 <= p00 + p10 + p20 + p30;
        stage2 <= stage1 + (p01 << 8) + (p11 << 8) + (p21 << 8) + (p31 << 8);
        stage3 <= stage2 + (p02 << 16) + (p12 << 16) + (p22 << 16) + (p32 << 16);
    end
end

// Final accumulation and output
always @(posedge clk) begin
    if (rst) begin
        c <= 32'd0;
    end else begin
        c <= stage3 + (p03 << 24) + (p13 << 24) + (p23 << 24) + (p33 << 24);
    end
end

endmodule