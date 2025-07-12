module pe (
    input clk,  // Clock signal
    input rst,  // Reset signal
    input [31:0] a,  // Input operand A
    input [31:0] b,  // Input operand B
    output [31:0] c  // Accumulated result
);

// Segmentation
wire [7:0] a_seg1, a_seg2, a_seg3, a_seg4;
wire [7:0] b_seg1, b_seg2, b_seg3, b_seg4;

assign a_seg1 = a[7:0];
assign a_seg2 = a[15:8];
assign a_seg3 = a[23:16];
assign a_seg4 = a[31:24];

assign b_seg1 = b[7:0];
assign b_seg2 = b[15:8];
assign b_seg3 = b[23:16];
assign b_seg4 = b[31:24];

// Parallel Multipliers
wire [15:0] mult1, mult2, mult3, mult4;

assign mult1 = a_seg1 * b_seg1;
assign mult2 = a_seg2 * b_seg2;
assign mult3 = a_seg3 * b_seg3;
assign mult4 = a_seg4 * b_seg4;

// Pipelined Accumulator
reg [31:0] stage1, stage2, stage3, stage4;

always @(posedge clk) begin
    if (rst) begin
        stage1 <= 32'd0;
        stage2 <= 32'd0;
        stage3 <= 32'd0;
        stage4 <= 32'd0;
    end else begin
        // Stage 1: Accumulate mult1 and mult2
        stage1 <= stage1 + (mult1 + (mult2 << 8));
        
        // Stage 2: Accumulate mult3
        stage2 <= stage2 + (mult3 << 16);
        
        // Stage 3: Accumulate stage1 and stage2
        stage3 <= stage3 + (stage1 + stage2);
        
        // Stage 4: Accumulate stage3 and mult4
        stage4 <= stage4 + (stage3 + (mult4 << 24));
    end
end

// Output Assignment
assign c = stage4;

endmodule