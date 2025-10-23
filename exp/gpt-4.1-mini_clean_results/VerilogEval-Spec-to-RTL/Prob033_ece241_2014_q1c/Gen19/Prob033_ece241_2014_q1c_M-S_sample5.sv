module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire [8:0] sum_ext;

    // Perform addition with one extra bit to catch carry out
    assign sum_ext = {1'b0, a} + {1'b0, b};
    assign s = sum_ext[7:0];

    // Overflow detection: 
    // overflow occurs if a and b have same sign but sum has different sign
    assign overflow = (~a[7] & ~b[7] & s[7]) | (a[7] & b[7] & ~s[7]);

endmodule