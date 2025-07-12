module TopModule (
    input in1,
    input in2,
    output out
);
    // Directly instantiate the built-in nor primitive for minimal area and power
    nor (out, in1, in2);
endmodule