module TopModule(
    input a,
    input b,
    output out
);
    assign out = ~((~a) & (~b)); // Using De Morgan's law for NOR: ~(a | b) = ~a & ~b, then inverting the result to match the NOR operation.
endmodule