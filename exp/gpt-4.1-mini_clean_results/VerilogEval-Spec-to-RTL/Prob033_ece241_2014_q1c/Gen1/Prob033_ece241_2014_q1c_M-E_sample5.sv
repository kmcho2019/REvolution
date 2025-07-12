module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output overflow
);
    wire [8:0] a_ext = {{1{a[7]}}, a};
    wire [8:0] b_ext = {{1{b[7]}}, b};
    wire [8:0] sum;

    assign sum = a_ext + b_ext;
    assign s = sum[7:0];

    // Overflow detection by comparing carry into and out of sign bit (bit 7)
    // carry into bit 7 = sum[7], carry out bit 7 = sum[8]
    // overflow if they differ
    assign overflow = sum[8] ^ sum[7];

endmodule