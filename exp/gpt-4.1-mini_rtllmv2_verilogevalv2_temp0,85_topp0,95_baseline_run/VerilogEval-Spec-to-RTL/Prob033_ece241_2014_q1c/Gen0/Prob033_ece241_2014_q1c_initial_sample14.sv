module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);

    wire [8:0] sum_ext;
    assign sum_ext = {a[7], a} + {b[7], b}; // extend sign bit for addition
    assign s = sum_ext[7:0];

    // Overflow occurs if the sign of a and b are the same but differ from the sign of s
    assign overflow = (~(a[7] ^ b[7])) & (a[7] ^ s[7]);

endmodule