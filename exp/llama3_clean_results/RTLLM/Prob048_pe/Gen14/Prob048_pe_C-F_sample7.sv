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

// Alignment and Addition
reg [31:0] c_reg;
reg [31:0] temp;
wire [31:0] add_result;

initial c_reg = 32'd0;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        c_reg <= 32'd0;
    end else begin
        temp = c_reg + (mult1 + (mult2 << 8) + (mult3 << 16) + (mult4 << 24));
        c_reg <= temp;
    end
end

// Pipelining
reg [31:0] pipeline_reg1, pipeline_reg2;
wire [31:0] pipeline_result;

always @(posedge clk) begin
    pipeline_reg1 <= mult1;
    pipeline_reg2 <= mult2;
    pipeline_result <= pipeline_reg1 + (pipeline_reg2 << 8);
end

// Output Assignment
assign c = c_reg + pipeline_result;

endmodule