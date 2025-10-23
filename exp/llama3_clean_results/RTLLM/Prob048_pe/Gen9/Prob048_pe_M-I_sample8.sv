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

// Pipeline Registers
reg [15:0] mult1_reg, mult2_reg, mult3_reg, mult4_reg;
reg [31:0] c_reg;

// Clock Enable Signal
reg clk_en;

// Sequential Logic for Accumulation
always @(posedge clk) begin
    if (rst) begin
        mult1_reg <= 16'd0;
        mult2_reg <= 16'd0;
        mult3_reg <= 16'd0;
        mult4_reg <= 16'd0;
        c_reg <= 32'd0;
        clk_en <= 1'b0;
    end else begin
        mult1_reg <= mult1;
        mult2_reg <= mult2;
        mult3_reg <= mult3;
        mult4_reg <= mult4;
        if (clk_en) begin
            c_reg <= c_reg + (mult1_reg + (mult2_reg << 8) + (mult3_reg << 16) + (mult4_reg << 24));
        end
        clk_en <= ~clk_en;
    end
end

// Output Assignment
assign c = c_reg;

endmodule