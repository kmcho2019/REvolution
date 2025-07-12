module TopModule (
    input  [3:0] x,
    input  [3:0] y,
    output [4:0] sum
);
    reg [4:0] sum_reg;

    always @(*) begin
        sum_reg = x + y; // 4-bit addition with overflow in 5th bit
    end

    assign sum = sum_reg;
endmodule