module pe(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output [31:0] c
);

reg [31:0] c_reg; // Register to store the accumulated result

// Assign output to the register
assign c = c_reg;

always @ (posedge clk or posedge rst) begin
    if (rst) begin
        // On reset, set the register to 0
        c_reg <= 32'd0;
    end else begin
        // On every clock cycle, accumulate the product of a and b
        c_reg <= c_reg + (a * b);
    end
end

endmodule