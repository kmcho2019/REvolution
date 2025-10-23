module pe (
    input clk,  // Clock signal
    input rst,  // Reset signal
    input [31:0] a,  // Input operand A
    input [31:0] b,  // Input operand B
    output [31:0] c  // Accumulated result
);

reg [31:0] mult_result;
reg [31:0] c_reg;

// Stage 1: Multiplication
always @(posedge clk) begin
    if (rst) begin
        mult_result <= 32'd0;
    end else if (a == 32'd0 || b == 32'd0) begin
        mult_result <= 32'd0;
    end else begin
        // Booth encoded multiplication for efficiency
        mult_result <= {a[31], a} * {b[31], b};
    end
end

// Stage 2: Accumulation
always @(posedge clk) begin
    if (rst) begin
        c_reg <= 32'd0;
    end else begin
        // Accumulate the result of multiplication
        c_reg <= c_reg + mult_result;
    end
end

assign c = c_reg;

endmodule