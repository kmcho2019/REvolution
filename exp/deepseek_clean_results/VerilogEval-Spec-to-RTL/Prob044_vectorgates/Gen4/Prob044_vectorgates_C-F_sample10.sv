module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);

    // Bitwise OR (continuous assignment)
    assign out_or_bitwise = a | b;

    // Logical OR (explicit intermediate signals)
    wire a_nonzero = |a;
    wire b_nonzero = |b;
    assign out_or_logical = a_nonzero || b_nonzero;

    // Vector NOT with proper bit ordering
    wire [2:0] not_a = ~a;
    wire [2:0] not_b = ~b;
    assign out_not = {not_b, not_a};

endmodule