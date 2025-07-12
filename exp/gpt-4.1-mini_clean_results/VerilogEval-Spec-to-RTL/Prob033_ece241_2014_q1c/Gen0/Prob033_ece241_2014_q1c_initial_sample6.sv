module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output overflow
);
    wire [8:0] sum_ext;
    assign sum_ext = {a[7], a} + {b[7], b};  // Extend sign bit to 9 bits for addition

    assign s = sum_ext[7:0];
    // Overflow if sign of a and b are same and sign of sum is different
    assign overflow = (~(a[7] ^ b[7])) & (a[7] ^ sum_ext[7]);

endmodule