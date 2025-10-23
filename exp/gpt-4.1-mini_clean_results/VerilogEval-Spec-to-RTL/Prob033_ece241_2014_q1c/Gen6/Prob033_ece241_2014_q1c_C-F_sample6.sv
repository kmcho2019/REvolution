module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    // Sign-extend inputs to 9 bits for carry detection
    wire [8:0] a_ext = {a[7], a};
    wire [8:0] b_ext = {b[7], b};
    wire [8:0] sum_ext;

    assign sum_ext = a_ext + b_ext;

    // Sum is lower 8 bits
    assign s = sum_ext[7:0];

    // Overflow occurs if carry into MSB differs from carry out of MSB
    // carry into MSB is sum_ext[7], carry out is sum_ext[8]
    // But sum_ext is the sum, so to get carries, we do:
    // overflow = carry_in_to_MSB ^ carry_out_of_MSB
    // Using the sign-extended addition method, overflow = (a[7] == b[7]) && (s[7] != a[7])

    // Alternatively, overflow = carry into MSB ^ carry out of MSB:
    // carry into MSB = sum_ext[7], carry out = sum_ext[8], but sum_ext is sum, not carry signals.
    // So to get carry bits explicitly, we can compute overflow as:
    // (a[7] & b[7] & ~s[7]) | (~a[7] & ~b[7] & s[7]) is the common signed overflow formula.

    assign overflow = (a[7] & b[7] & ~s[7]) | (~a[7] & ~b[7] & s[7]);

endmodule