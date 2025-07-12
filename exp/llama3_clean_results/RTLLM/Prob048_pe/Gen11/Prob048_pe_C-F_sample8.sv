module pe (
    input clk,  // Clock signal
    input rst,  // Reset signal
    input [31:0] a,  // Input operand A
    input [31:0] b,  // Input operand B
    output [31:0] c  // Accumulated result
);

// Segmentation
wire [15:0] a_seg1, a_seg2;
wire [15:0] b_seg1, b_seg2;

assign a_seg1 = a[15:0];
assign a_seg2 = a[31:16];

assign b_seg1 = b[15:0];
assign b_seg2 = b[31:16];

// Parallel Multipliers
wire [31:0] mult1, mult2;

assign mult1 = {16'd0, a_seg1} * {16'd0, b_seg1};
assign mult2 = {16'd0, a_seg2} * {16'd0, b_seg2};

// Accumulator Register
reg [31:0] c_reg;

// Sequential Logic for Accumulation
always @(posedge clk) begin
    if (rst) begin
        c_reg <= 32'd0;
    end else begin
        c_reg <= c_reg + mult1 + mult2;
    end
end

// Output Assignment
assign c = c_reg;

endmodule