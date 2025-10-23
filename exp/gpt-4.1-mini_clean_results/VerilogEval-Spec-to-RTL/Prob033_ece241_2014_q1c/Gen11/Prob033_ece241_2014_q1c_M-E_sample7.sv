module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire signed [8:0] sum_ext;  // Extend to 9 bits to detect overflow

    assign sum_ext = {a[7], a} + {b[7], b}; // sign-extend before addition
    assign s = sum_ext[7:0];

    // Overflow occurs if the sign of a and b are the same, but different from sum
    assign overflow = (~(a[7] ^ b[7])) & (a[7] ^ s[7]);

endmodule