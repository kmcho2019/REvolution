module TopModule(
    input  in1,
    input  in2,
    output out
);
    // The current implementation is already optimal for a NOR gate.
    // However, for completeness, an alternative expression could be used,
    // though it should synthesize to the same logic as the original.
    assign out = ~in1 & ~in2;
endmodule