module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);

    // Sign-extend inputs to 9 bits to accurately represent signed numbers
    wire [8:0] a_ext = {a[7], a};
    wire [8:0] b_ext = {b[7], b};
    wire [8:0] sum_ext = a_ext + b_ext;

    assign s = sum_ext[7:0];

    // Overflow occurs when inputs have same sign but result sign differs
    assign overflow = (~(a[7] ^ b[7])) & (a[7] ^ sum_ext[8]);

endmodule