module pe (
    input clk, 
    input rst, 
    input [31:0] a, 
    input [31:0] b, 
    output reg [31:0] c
);

reg [31:0] product;
reg [31:0] next_c;

always @(posedge clk) begin
    if (rst) begin
        c <= 0;
        product <= 0;
    end else begin
        c <= next_c;
        product <= a * b;
    end
end

always @(*) begin
    if (rst) 
        next_c = 0;
    else 
        next_c = c + product;
end

endmodule