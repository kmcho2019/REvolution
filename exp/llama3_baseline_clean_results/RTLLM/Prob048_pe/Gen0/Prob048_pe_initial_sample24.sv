module pe(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output [31:0] c
);

reg [31:0] c_reg;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        // Reset the accumulator to 0 when reset is active
        c_reg <= 32'd0;
    end else begin
        // Multiply a and b, then add the result to the accumulator
        c_reg <= c_reg + (a * b);
    end
end

assign c = c_reg;

endmodule