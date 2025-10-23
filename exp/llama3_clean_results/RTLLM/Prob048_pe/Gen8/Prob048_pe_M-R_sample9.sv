module pe (
    input clk,  // Clock signal
    input rst,  // Reset signal
    input [31:0] a,  // Input operand A
    input [31:0] b,  // Input operand B
    output [31:0] c  // Accumulated result
);

reg [31:0] c_reg;  // Register to store the accumulated result
reg [31:0] mult_result;  // Register to store the result of multiplication

// Sequential logic for multiplication
always @(posedge clk) begin
    if (rst) begin
        mult_result <= 32'd0;
    end else begin
        mult_result <= a * b;
    end
end

// Sequential logic for accumulation
always @(posedge clk) begin
    if (rst) begin
        c_reg <= 32'd0;
    end else begin
        c_reg <= c_reg + mult_result;
    end
end

// Output assignment
assign c = c_reg;

endmodule