module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire [8:0] sum_ext;

    // Extend inputs to 9 bits with sign extension for correct signed addition
    assign sum_ext = {a[7], a} + {b[7], b};

    assign s = sum_ext[7:0];

    // Overflow occurs if the carry into MSB differs from carry out of MSB
    // or equivalently, if sign of sum differs from sign of inputs when inputs have same sign
    assign overflow = (a[7] == b[7]) && (s[7] != a[7]);

endmodule