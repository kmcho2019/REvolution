module pe (
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] c
);

wire [31:0] mult_result;
assign mult_result = a * b;

always @ (posedge clk or posedge rst) begin
    if (rst) begin
        c <= 0;
    end else begin
        c <= c + mult_result;
    end
end

endmodule