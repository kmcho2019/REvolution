module TopModule (
    input  [2:0] a,
    input  [2:0] b,
    output reg [2:0] out_or_bitwise,
    output reg       out_or_logical,
    output reg [5:0] out_not
);
    always @(*) begin
        out_or_bitwise = a | b;          // bitwise OR
        out_or_logical = |a || |b;       // logical OR of all bits of a and b
        out_not = {~b, ~a};              // upper 3 bits: ~b, lower 3 bits: ~a
    end
endmodule