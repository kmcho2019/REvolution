module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire [8:0] sum_ext;

    // Extend inputs to 9 bits to detect carry out naturally
    assign sum_ext = {a[7], a} + {b[7], b};
    assign s = sum_ext[7:0];

    // Overflow if sign of a and b are same but different from s
    assign overflow = (~(a[7] ^ b[7])) & (a[7] ^ s[7]);
endmodule