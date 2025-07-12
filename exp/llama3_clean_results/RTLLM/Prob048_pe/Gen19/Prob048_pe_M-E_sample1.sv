module pe (
    input clk,  // Clock signal
    input rst,  // Reset signal
    input [31:0] a,  // Input operand A
    input [31:0] b,  // Input operand B
    output [31:0] c  // Accumulated result
);

reg [31:0] mult_reg;  // Register to store multiplication result
reg [31:0] accum_reg;  // Register to store accumulated result

always @(posedge clk) begin
    if (rst) begin
        mult_reg <= 32'd0;
        accum_reg <= 32'd0;
    end else begin
        mult_reg <= a * b;  // Perform multiplication
        accum_reg <= accum_reg + mult_reg;  // Perform accumulation
    end
end

assign c = accum_reg;  // Assign accumulated result to output

endmodule