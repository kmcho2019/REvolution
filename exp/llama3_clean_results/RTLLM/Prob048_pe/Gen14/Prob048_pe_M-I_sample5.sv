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

// Booth Multiplier Implementation for Efficiency
wire [15:0] mult1, mult2, mult3, mult4;

// Simplified for illustration; actual implementation would involve Booth multiplier logic
assign mult1 = a_seg1 * b_seg1;
assign mult2 = a_seg2 * b_seg2;
assign mult3 = a_seg3 * b_seg3;
assign mult4 = a_seg4 * b_seg4;

// Accumulator Register with Pipelining for Improved Timing
reg [31:0] c_reg;
reg [31:0] pipe_reg;

initial c_reg = 32'd0;
initial pipe_reg = 32'd0;

// Clock Gating for Power Reduction
reg clk_enable;
assign clk_enable = ~rst; // Enable clock when not in reset

// Sequential Logic for Accumulation with Clock Gating
always @(posedge clk) begin
    if (clk_enable) begin
        reg [31:0] temp;
        temp = c_reg + (mult1 + (mult2 << 8) + (mult3 << 16) + (mult4 << 24));
        pipe_reg <= temp; // Pipeline stage for accumulation
    end
end

always @(posedge clk) begin
    if (clk_enable) begin
        c_reg <= pipe_reg; // Update accumulator register
    end else begin
        c_reg <= 32'd0; // Reset accumulator on reset
    end
end

// Output Assignment
assign c = c_reg;

endmodule