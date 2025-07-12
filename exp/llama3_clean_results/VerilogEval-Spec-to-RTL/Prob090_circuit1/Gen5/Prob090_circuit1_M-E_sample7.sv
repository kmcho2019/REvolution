module TopModule(
    input  a,
    input  b,
    output q
);

    wire not_a, not_b;
    assign not_a = ~a;
    assign not_b = ~b;
    assign q = ~(not_a | not_b);

endmodule