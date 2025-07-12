module TopModule (
    input  [2:0] a,
    input  [2:0] b,
    output reg [2:0] out_or_bitwise,
    output reg       out_or_logical,
    output reg [5:0] out_not
);

    always @* begin
        // Compute bitwise OR bit-by-bit
        out_or_bitwise[0] = a[0] | b[0];
        out_or_bitwise[1] = a[1] | b[1];
        out_or_bitwise[2] = a[2] | b[2];

        // Compute logical OR by OR-ing reductions of a and b
        out_or_logical = (a[0] | a[1] | a[2]) | (b[0] | b[1] | b[2]);

        // Compute NOTs individually and concatenate
        out_not = {~b[2], ~b[1], ~b[0], ~a[2], ~a[1], ~a[0]};
    end

endmodule