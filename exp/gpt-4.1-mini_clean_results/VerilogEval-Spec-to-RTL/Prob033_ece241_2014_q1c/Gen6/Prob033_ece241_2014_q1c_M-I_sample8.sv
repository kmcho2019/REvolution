module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire [8:0] sum_ext;

    assign sum_ext = {1'b0, a} + {1'b0, b};  // 9-bit to catch carry out

    assign s = sum_ext[7:0];

    // Overflow detection for signed addition:
    // overflow = (a[7] == b[7]) && (s[7] != a[7])
    assign overflow = (~(a[7] ^ b[7])) & (a[7] ^ s[7]);

endmodule