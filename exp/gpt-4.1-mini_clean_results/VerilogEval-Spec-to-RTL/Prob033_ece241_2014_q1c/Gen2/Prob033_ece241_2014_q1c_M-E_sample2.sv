module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output overflow
);
    // Treat inputs as signed 8-bit numbers
    wire signed [7:0] a_signed = a;
    wire signed [7:0] b_signed = b;
    wire signed [8:0] sum_ext = a_signed + b_signed; // 9-bit to capture overflow

    assign s = sum_ext[7:0];
    // Overflow if sign of a and b are same, but sign of sum differs
    assign overflow = (~(a[7] ^ b[7])) & (a[7] ^ sum_ext[7]);

endmodule