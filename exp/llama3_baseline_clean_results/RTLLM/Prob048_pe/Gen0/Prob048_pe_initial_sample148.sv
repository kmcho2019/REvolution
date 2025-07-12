module pe (
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] c
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        c <= 32'd0; // Reset the accumulator to 0 when reset signal is high
    end else begin
        c <= c + (a * b); // Accumulate the product of a and b when reset signal is low
    end
end

endmodule