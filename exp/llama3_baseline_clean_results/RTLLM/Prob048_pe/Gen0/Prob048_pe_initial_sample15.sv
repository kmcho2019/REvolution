module pe(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] c
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        c <= 32'd0; // reset c to 0 when rst is high
    end else begin
        c <= c + (a * b); // accumulate the product of a and b in c
    end
end

endmodule