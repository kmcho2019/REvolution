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

// LUT-based Multiplication
reg [15:0] lut_result1, lut_result2, lut_result3, lut_result4;

always @(posedge clk) begin
    if (rst) begin
        lut_result1 <= 16'd0;
        lut_result2 <= 16'd0;
        lut_result3 <= 16'd0;
        lut_result4 <= 16'd0;
    end else begin
        lut_result1 <= {8'd0, a_seg1} * {8'd0, b_seg1};
        lut_result2 <= {8'd0, a_seg2} * {8'd0, b_seg2};
        lut_result3 <= {8'd0, a_seg3} * {8'd0, b_seg3};
        lut_result4 <= {8'd0, a_seg4} * {8'd0, b_seg4};
    end
end

// DSP-based Accumulation
reg [31:0] c_reg;
wire [31:0] add_result;

always @(posedge clk) begin
    if (rst) begin
        c_reg <= 32'd0;
    end else begin
        c_reg <= c_reg + add_result;
    end
end

assign add_result = (lut_result1 << 0) + (lut_result2 << 8) + (lut_result3 << 16) + (lut_result4 << 24);

// Output Assignment
assign c = c_reg;

endmodule