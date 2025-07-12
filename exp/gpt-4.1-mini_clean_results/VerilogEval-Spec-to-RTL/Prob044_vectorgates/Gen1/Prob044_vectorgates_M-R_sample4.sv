module TopModule (
    input  [2:0] a,
    input  [2:0] b,
    output reg [2:0] out_or_bitwise,
    output reg       out_or_logical,
    output reg [5:0] out_not
);

    always @(*) begin
        // bitwise OR of a and b
        out_or_bitwise = a | b;

        // logical OR of any bit in a or b
        out_or_logical = (|a) | (|b);

        // inverse of b in upper half [5:3]
        out_not[5:3] = ~b;

        // inverse of a in lower half [2:0]
        out_not[2:0] = ~a;
    end

endmodule