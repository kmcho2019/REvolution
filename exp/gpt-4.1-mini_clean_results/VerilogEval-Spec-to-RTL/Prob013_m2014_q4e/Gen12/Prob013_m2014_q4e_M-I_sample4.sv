module TopModule (
    input in1,
    input in2,
    output out
);
    // Directly instantiate the nor primitive for minimal overhead and best PPA
    nor (out, in1, in2);
endmodule