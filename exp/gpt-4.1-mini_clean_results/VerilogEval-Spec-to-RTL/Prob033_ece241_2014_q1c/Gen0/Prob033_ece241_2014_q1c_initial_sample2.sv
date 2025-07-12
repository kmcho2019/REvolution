module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    // Use signed wires for proper signed arithmetic
    wire signed [7:0] a_signed = a;
    wire signed [7:0] b_signed = b;
    wire signed [8:0] sum_ext = a_signed + b_signed;  // 9 bits to detect carry out

    assign s = sum_ext[7:0];

    // Overflow detection: occurs if the sign of a and b are same but different from s
    assign overflow = (~a[7] & ~b[7] & s[7]) | (a[7] & b[7] & ~s[7]);

endmodule