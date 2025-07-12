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
reg [15:0] mult_reg1, mult_reg2, mult_reg3, mult_reg4;
reg [31:0] add_reg;

// Accumulator Register
reg [31:0] c_reg;

initial c_reg = 32'd0;

// Clock Gating
reg clk_gated;
always @(posedge clk) begin
    if (rst) begin
        clk_gated <= 1'b0;
    end else begin
        clk_gated <= 1'b1;
    end
end

// Pipeline Stage 1: Multiplication
always @(posedge clk_gated or posedge rst) begin
    if (rst) begin
        mult_reg1 <= 16'd0;
        mult_reg2 <= 16'd0;
        mult_reg3 <= 16'd0;
        mult_reg4 <= 16'd0;
    end else begin
        mult_reg1 <= mult1;
        mult_reg2 <= mult2;
        mult_reg3 <= mult3;
        mult_reg4 <= mult4;
    end
end

// Pipeline Stage 2: Addition
always @(posedge clk_gated or posedge rst) begin
    if (rst) begin
        add_reg <= 32'd0;
    end else begin
        reg [31:0] temp;
        temp = (mult_reg1 + (mult_reg2 << 8) + (mult_reg3 << 16) + (mult_reg4 << 24));
        add_reg <= temp;
    end
end

// Pipeline Stage 3: Accumulation
always @(posedge clk_gated or posedge rst) begin
    if (rst) begin
        c_reg <= 32'd0;
    end else begin
        c_reg <= c_reg + add_reg;
    end
end

// Output Assignment
assign c = c_reg;

endmodule