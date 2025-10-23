module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire signed [7:0] a_signed = a;
    wire signed [7:0] b_signed = b;
    wire signed [8:0] sum_extended;

    assign sum_extended = a_signed + b_signed; 
    assign s = sum_extended[7:0];

    // Overflow occurs if sign of a == sign of b but sign of sum differs
    assign overflow = (~(a[7] ^ b[7])) & (a[7] ^ s[7]);

endmodule