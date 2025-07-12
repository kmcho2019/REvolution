module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    // Treat inputs as signed values for addition
    wire signed [7:0] a_signed = a;
    wire signed [7:0] b_signed = b;
    wire signed [8:0] sum_ext; // Use 9 bits to hold full sum with carry out

    assign sum_ext = a_signed + b_signed;

    assign s = sum_ext[7:0];

    // Overflow detection for 2's complement addition:
    // Overflow occurs if a and b have same sign, but sum has different sign
    assign overflow = (~(a[7] ^ b[7])) & (a[7] ^ s[7]);

endmodule