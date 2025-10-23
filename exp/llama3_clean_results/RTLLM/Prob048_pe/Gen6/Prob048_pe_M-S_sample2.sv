module pe (
    input clk,  // Clock signal
    input rst,  // Reset signal
    input [31:0] a,  // Input operand A
    input [31:0] b,  // Input operand B
    output [31:0] c  // Accumulated result
);

reg [31:0] c_reg;  // Register to store the accumulated result

assign c = c_reg;  // Assign output

always @(posedge clk or posedge rst) begin
    if (rst) begin
        c_reg <= 32'd0;
    end else begin
        c_reg <= c_reg + (a * b);
    end
end

endmodule