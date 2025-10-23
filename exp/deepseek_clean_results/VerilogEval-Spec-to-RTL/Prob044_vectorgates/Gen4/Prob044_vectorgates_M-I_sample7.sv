module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);

    // Bitwise OR of a and b (optimal implementation)
    assign out_or_bitwise = a | b;

    // Optimized logical OR: OR of reduction ORs of a and b
    assign out_or_logical = (|a) || (|b);

    // NOT operations (optimal implementation):
    // Upper 3 bits are ~b, lower 3 bits are ~a
    assign out_not[5:3] = ~b;
    assign out_not[2:0] = ~a;

endmodule