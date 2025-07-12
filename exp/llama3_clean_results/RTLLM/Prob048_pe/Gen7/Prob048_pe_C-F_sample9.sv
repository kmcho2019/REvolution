module pe (
    input clk,  // Clock signal
    input rst,  // Reset signal
    input [31:0] a,  // Input operand A
    input [31:0] b,  // Input operand B
    output [31:0] c  // Accumulated result
);

// Segmentation of input operands into 16-bit segments
wire [15:0] a_seg1, a_seg2;
wire [15:0] b_seg1, b_seg2;

assign a_seg1 = a[15:0];
assign a_seg2 = a[31:16];
assign b_seg1 = b[15:0];
assign b_seg2 = b[31:16];

// Efficient 16-bit multiplier
wire [31:0] mult_result;

assign mult_result = (a_seg1 * b_seg1) + ((a_seg2 * b_seg1) << 16) + ((a_seg1 * b_seg2) << 16) + ((a_seg2 * b_seg2) << 32);

// Pipelined accumulation
reg [31:0] c_reg;  // Register to store the accumulated result

always @(posedge clk) begin
    if (rst) begin
        c_reg <= 32'd0;
    end else begin
        c_reg <= c_reg + mult_result[31:0];  // Accumulate the 32-bit result
    end
end

assign c = c_reg;

endmodule