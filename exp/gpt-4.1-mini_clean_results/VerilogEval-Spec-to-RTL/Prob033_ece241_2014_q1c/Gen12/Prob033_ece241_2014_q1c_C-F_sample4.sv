module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire [8:0] full_sum;

    // Perform 8-bit addition with one extra bit for carry out
    assign full_sum = {1'b0, a} + {1'b0, b};
    assign s = full_sum[7:0];

    // Overflow occurs if sign of a and b are the same but sign of sum differs
    assign overflow = (~(a[7] ^ b[7])) & (a[7] ^ s[7]);
endmodule