module TopModule(
    input  in,
    output out
);
    // The original implementation is already optimal for a NOT gate.
    // To potentially improve PPA metrics further, one might consider
    // applying synthesis directives or attributes specific to the target technology.
    // However, for a simple NOT gate, such optimizations are likely to be minimal.
    assign out = ~in;
endmodule