module pe (
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output [31:0] c
);

reg [31:0] c_reg = 0;

// Adding synthesis directives to optimize for area
// `synopsys dc_multstyle "lut"
// `synopsys dc_cur_glbl

always @(posedge clk or posedge rst) begin
    if (rst) begin
        c_reg <= 32'd0;
    end else begin
        // Using the direct multiplication for simplicity and potential optimization by synthesis tool
        c_reg <= c_reg + (a * b);
    end
end

assign c = c_reg;

endmodule