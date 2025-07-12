module TopModule (
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);

    wire [5:0] combined;

    // Combine inputs for single reduction
    assign combined = {a, b};

    // Bitwise OR of a and b
    assign out_or_bitwise = a | b;

    // Logical OR of all bits of a and b combined using single reduction
    assign out_or_logical = |combined;

    // Inverse of b in bits [5:3], inverse of a in bits [2:0]
    assign out_not = { ~b, ~a };

endmodule