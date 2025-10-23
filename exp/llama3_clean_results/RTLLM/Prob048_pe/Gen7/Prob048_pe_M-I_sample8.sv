module pe (
    input clk,  // Clock signal
    input rst,  // Reset signal
    input [31:0] a,  // Input operand A
    input [31:0] b,  // Input operand B
    output [31:0] c  // Accumulated result
);

reg [31:0] mult_reg;  // Register to store the multiplication result
reg [31:0] c_reg;  // Register to store the accumulated result
reg clk_en;  // Clock enable signal

// Apply clock gating
always @(posedge clk) begin
    if (rst) begin
        clk_en <= 1'b0;
    end else if (a !== 32'd0 || b !== 32'd0) begin
        clk_en <= 1'b1;
    end else begin
        clk_en <= 1'b0;
    end
end

// Pipeline the multiplication operation
always @(posedge clk) begin
    if (rst) begin
        mult_reg <= 32'd0;
    end else if (clk_en) begin
        mult_reg <= a * b;
    end
end

// Accumulate the result
always @(posedge clk) begin
    if (rst) begin
        c_reg <= 32'd0;
    end else if (clk_en) begin
        c_reg <= c_reg + mult_reg;
    end
end

assign c = c_reg;  // Continuous assignment for output

endmodule