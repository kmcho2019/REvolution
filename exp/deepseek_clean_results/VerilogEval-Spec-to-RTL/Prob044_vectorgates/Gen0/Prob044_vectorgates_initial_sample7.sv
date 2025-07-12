module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);

    // Bitwise OR between a and b
    assign out_or_bitwise = a | b;

    // Logical OR (true if either a or b is non-zero)
    assign out_or_logical = (|a) || (|b);

    // NOT operations concatenated with ~b in upper bits, ~a in lower bits
    assign out_not = {~b, ~a};

endmodule