module pe (
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] c
);

always @ (posedge clk or posedge rst) begin
    if (rst) begin
        c <= 32'd0;  // Reset the accumulator to 0 when rst is high
    end else begin
        c <= c + (a * b);  // Update the accumulator by adding the product of a and b
    end
end

endmodule