module pe (
    input wire clk,
    input wire rst,
    input wire [31:0] a,
    input wire [31:0] b,
    output reg [31:0] c
);

always @(posedge clk) begin
    if (rst) begin
        c <= 32'd0;
    end else begin
        c <= c + (a * b);
    end
end

endmodule