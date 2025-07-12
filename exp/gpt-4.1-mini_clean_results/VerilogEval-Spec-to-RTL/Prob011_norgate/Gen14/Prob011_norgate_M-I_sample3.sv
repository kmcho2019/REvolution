module TopModule(
    input  a,
    input  b,
    output wire out  // Output declared explicitly as wire for clarity
);
    // 2-input NOR gate implemented using built-in nor primitive
    nor (out, a, b);
endmodule