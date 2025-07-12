module pe (
    input clk, 
    input rst, 
    input [31:0] a, 
    input [31:0] b, 
    output reg [31:0] c
);

always @ (posedge clk or posedge rst) begin
    if (rst) begin
        // Reset the accumulator register
        c <= 32'd0;
    end else begin
        // Multiply and accumulate
        c <= c + (a * b);
    end
end

endmodule