module TopModule (
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);

    // Bitwise OR of inputs a and b
    wire [2:0] or_result = a | b;
    assign out_or_bitwise = or_result;

    // Logical OR over concatenated inputs (equivalent to logical OR of each vector combined)
    assign out_or_logical = |{a, b};

    // Bitwise NOT of a and b
    wire [2:0] not_a = ~a;
    wire [2:0] not_b = ~b;

    // Place bitwise NOT of b in upper half [5:3], bitwise NOT of a in lower half [2:0]
    assign out_not = {not_b, not_a};

endmodule