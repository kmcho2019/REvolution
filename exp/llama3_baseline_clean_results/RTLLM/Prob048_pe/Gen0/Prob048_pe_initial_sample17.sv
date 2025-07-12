module pe (
    input clk, 
    input rst, 
    input [31:0] a, 
    input [31:0] b, 
    output [31:0] c
);

reg [31:0] c;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        c <= 32'd0; // Reset register 'c' to 0 when reset signal is high
    end else begin
        c <= c + (a * b); // Accumulate the product of 'a' and 'b' into register 'c'
    end
end

endmodule