module pe (
    input clk,  // Clock signal
    input rst,  // Reset signal
    input [31:0] a,  // Input operand A
    input [31:0] b,  // Input operand B
    output [31:0] c  // Accumulated result
);

// Hybrid Multiplication Approach
wire [15:0] a_high, a_low;
wire [15:0] b_high, b_low;

assign a_high = a[31:16];
assign a_low = a[15:0];
assign b_high = b[31:16];
assign b_low = b[15:0];

wire [31:0] mult_high, mult_low;

assign mult_high = {16'd0, a_high} * {16'd0, b_high};
assign mult_low = {16'd0, a_low} * {16'd0, b_low};

// Accumulator Register
reg [31:0] c_reg;

// Sequential Logic for Accumulation
always @(posedge clk) begin
    if (rst) begin
        c_reg <= 32'd0;
    end else begin
        c_reg <= c_reg + (mult_high + mult_low);
    end
end

// Output Assignment
assign c = c_reg;

endmodule