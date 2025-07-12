module TopModule (
    input in1,
    input in2,
    output out
);
    // Direct logic expression: NOR is NOT(OR(in1, in2))
    assign out = ~(in1 | in2);
endmodule