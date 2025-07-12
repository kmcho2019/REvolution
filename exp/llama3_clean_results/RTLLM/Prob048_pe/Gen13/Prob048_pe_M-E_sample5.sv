module pe (
    input clk,  // Clock signal
    input rst,  // Reset signal
    input [31:0] a,  // Input operand A
    input [31:0] b,  // Input operand B
    output [31:0] c  // Accumulated result
);

// Pipeline registers
reg [31:0] a_reg;
reg [31:0] b_reg;
reg [31:0] mult_reg;
reg [31:0] accum_reg;

// Pipeline stages
always @(posedge clk or posedge rst) begin
    if (rst) begin
        a_reg <= 32'd0;
        b_reg <= 32'd0;
        mult_reg <= 32'd0;
        accum_reg <= 32'd0;
    end else begin
        // Fetch stage
        a_reg <= a;
        b_reg <= b;

        // Multiplication stage
        mult_reg <= a_reg * b_reg;

        // Accumulation stage
        accum_reg <= accum_reg + mult_reg;
    end
end

// Output stage
assign c = accum_reg;

endmodule