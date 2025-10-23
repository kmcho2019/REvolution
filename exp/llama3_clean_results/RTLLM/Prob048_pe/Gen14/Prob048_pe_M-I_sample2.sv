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

// Single Multiplier with Time-Multiplexed Inputs
reg [15:0] mult;
reg [1:0] mult_sel;

always @(posedge clk) begin
    if (rst) begin
        mult_sel <= 2'b00;
    end else begin
        case (mult_sel)
            2'b00: mult <= a_seg1 * b_seg1;
            2'b01: mult <= a_seg2 * b_seg2;
            2'b10: mult <= a_seg3 * b_seg3;
            2'b11: mult <= a_seg4 * b_seg4;
        endcase
        mult_sel <= mult_sel + 1;
    end
end

// Pipelined Adder
reg [31:0] add_reg1, add_reg2;
wire [31:0] add_result;

always @(posedge clk) begin
    if (rst) begin
        add_reg1 <= 32'd0;
        add_reg2 <= 32'd0;
    end else begin
        add_reg1 <= mult;
        add_reg2 <= add_reg1 + add_reg2;
    end
end

assign add_result = add_reg2;

// Clock Gating
reg clk_enable;
always @(posedge clk) begin
    if (rst) begin
        clk_enable <= 1'b0;
    end else begin
        clk_enable <= ~clk_enable;
    end
end

// Accumulator Register
reg [31:0] c_reg;
always @(posedge clk) begin
    if (rst || ~clk_enable) begin
        c_reg <= 32'd0;
    end else begin
        c_reg <= c_reg + add_result;
    end
end

// Output Assignment
assign c = c_reg;

endmodule