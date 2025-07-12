module TopModule (
    input  [2:0] a,
    input  [2:0] b,
    output reg [2:0] out_or_bitwise,
    output reg       out_or_logical,
    output reg [5:0] out_not
);

    always @(*) begin
        // Bitwise OR of a and b
        out_or_bitwise <= a | b;

        // Logical OR reduction over combined inputs (single reduction for minimal power)
        out_or_logical <= |(a | b);

        // Concatenate inverse of b (upper bits) and a (lower bits)
        out_not <= { ~b, ~a };
    end

endmodule