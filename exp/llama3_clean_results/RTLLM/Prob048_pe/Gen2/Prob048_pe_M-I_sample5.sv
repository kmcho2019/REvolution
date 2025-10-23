module pe (
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output [31:0] c
);

reg [31:0] c_reg;
reg [31:0] product;

assign c = c_reg;

// Pipelined multiplication and accumulation
always @(posedge clk or posedge rst) begin
    if (rst) begin
        c_reg <= 32'd0;
        product <= 32'd0;
    end else begin
        product <= a * b;
        c_reg <= c_reg + product;
    end
end

endmodule