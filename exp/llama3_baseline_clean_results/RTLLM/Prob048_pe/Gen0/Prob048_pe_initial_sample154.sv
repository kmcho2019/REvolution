module pe (
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output [31:0] c
);

reg [31:0] c_reg; // Internal register to store the accumulated result
assign c = c_reg; // Continuous assignment to output the accumulated result

always @ (posedge clk or posedge rst) begin
    if (rst) begin // If reset signal is high, reset the register
        c_reg <= 32'd0;
    end else begin // If reset signal is low, accumulate the product of a and b
        c_reg <= c_reg + (a * b);
    end
end

endmodule