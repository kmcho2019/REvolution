module TopModule (
    input  [2:0] a,
    input  [2:0] b,
    output reg [2:0] out_or_bitwise,
    output reg       out_or_logical,
    output reg [5:0] out_not
);

    always @(*) begin
        // Bitwise OR of a and b
        out_or_bitwise = a | b;
        // Logical OR: reduction OR of bitwise OR result
        out_or_logical = |out_or_bitwise;
        // Concatenate NOT of b (upper half) and NOT of a (lower half)
        out_not = {~b, ~a};
    end

endmodule