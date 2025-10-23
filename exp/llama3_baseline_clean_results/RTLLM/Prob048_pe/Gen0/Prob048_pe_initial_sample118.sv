module pe (
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output [31:0] c
);

reg [31:0] c_reg;  // accumulator register

assign c = c_reg;  // assign output 'c' to the accumulator register

always @(posedge clk or posedge rst) begin
    if (rst) begin
        // reset the accumulator register
        c_reg <= 32'd0;
    end else begin
        // multiply and accumulate
        c_reg <= c_reg + (a * b);
    end
end

endmodule