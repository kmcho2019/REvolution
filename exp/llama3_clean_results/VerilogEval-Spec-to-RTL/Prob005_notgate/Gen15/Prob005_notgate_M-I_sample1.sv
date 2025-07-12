module TopModule(
    input  in,
    output out
);
    // The current implementation is already optimal for a NOT gate.
    // To further optimize, one might consider synthesis attributes or options,
    // but for a simple NOT gate, the difference would be negligible.
    assign out = ~in;
endmodule