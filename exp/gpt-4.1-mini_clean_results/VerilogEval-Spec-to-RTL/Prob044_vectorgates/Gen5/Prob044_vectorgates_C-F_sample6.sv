module TopModule (
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);

    // Intermediate signals for clarity (not module instantiations)
    wire [2:0] bitwise_or = a | b;
    wire [2:0] not_a     = ~a;
    wire [2:0] not_b     = ~b;

    assign out_or_bitwise = bitwise_or;
    assign out_or_logical = |bitwise_or;
    assign out_not = {not_b, not_a};

endmodule