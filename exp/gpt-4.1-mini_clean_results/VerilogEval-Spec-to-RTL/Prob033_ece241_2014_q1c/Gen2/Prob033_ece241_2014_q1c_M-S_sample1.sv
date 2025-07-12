module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output overflow
);

    wire [8:0] sum;
    assign sum = {a[7], a} + {b[7], b};
    assign s = sum[7:0];

    // Overflow detection: same sign inputs but result sign differs
    assign overflow = (~(a[7] ^ b[7])) & (a[7] ^ sum[8]);

endmodule