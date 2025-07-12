module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire [8:0] sum;

    assign sum = {1'b0, a} + {1'b0, b};  // 9-bit addition to capture carry out

    assign s = sum[7:0];

    // Overflow for 2's complement addition occurs when:
    // a[7] == b[7] but s[7] != a[7]
    assign overflow = (~(a[7] ^ b[7])) & (a[7] ^ s[7]);

endmodule