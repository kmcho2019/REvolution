module pe(
    input clk, 
    input rst, 
    input [31:0] a, 
    input [31:0] b, 
    output [31:0] c
);

reg [31:0] c_reg; // register to store the accumulated result
assign c = c_reg; // output the accumulated result

always @ (posedge clk or posedge rst) begin
    if (rst) begin // reset condition
        c_reg <= 32'd0; // set register to 0
    end else begin
        c_reg <= c_reg + (a * b); // accumulate the product of a and b
    end
end

endmodule