module pe (
    input clk,  // Clock signal
    input rst,  // Reset signal
    input [31:0] a,  // Input operand A
    input [31:0] b,  // Input operand B
    output [31:0] c  // Accumulated result
);

// Registers to store the operands
reg [31:0] a_reg;
reg [31:0] b_reg;

// Register to store the accumulated result
reg [31:0] c_reg;

// Pipeline registers for multiplication result
reg [31:0] mult_reg;

always @(posedge clk) begin
    if (rst) begin
        a_reg <= 32'd0;
        b_reg <= 32'd0;
        c_reg <= 32'd0;
        mult_reg <= 32'd0;
    end else begin
        a_reg <= a;
        b_reg <= b;
        
        // Perform multiplication
        mult_reg <= a_reg * b_reg;
        
        // Accumulate the result
        c_reg <= c_reg + mult_reg;
    end
end

assign c = c_reg;

endmodule