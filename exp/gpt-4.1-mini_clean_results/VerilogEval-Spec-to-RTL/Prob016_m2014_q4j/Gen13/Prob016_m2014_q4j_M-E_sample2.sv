module TopModule(
    input  [3:0] x,
    input  [3:0] y,
    output reg [4:0] sum
);
    always @(*) begin
        sum = x + y;  // 4-bit addition with 5-bit sum including overflow
    end
endmodule