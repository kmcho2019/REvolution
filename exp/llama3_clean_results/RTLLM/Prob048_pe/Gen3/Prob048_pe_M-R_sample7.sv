module pe (
    input clk, 
    input rst, 
    input [31:0] a, 
    input [31:0] b, 
    output reg [31:0] c
);

reg [31:0] next_c;

always @(posedge clk) begin
    if (rst) 
        c <= 0;
    else 
        c <= next_c;
end

always @(*) begin
    if (rst) 
        next_c = 0;
    else 
        next_c = c + (a * b);
end

endmodule