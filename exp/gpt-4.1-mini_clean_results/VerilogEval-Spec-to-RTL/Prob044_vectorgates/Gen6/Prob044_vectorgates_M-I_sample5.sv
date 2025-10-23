module TopModule (
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);

    // Bitwise OR directly assigned
    assign out_or_bitwise = a | b;

    // Logical OR computed as (|a) | (|b), avoiding intermediate bitwise OR vector
    assign out_or_logical = (|a) | (|b);

    // Concatenate inverted b (upper half) and inverted a (lower half), inline without extra wires
    assign out_not = {~b, ~a};

endmodule