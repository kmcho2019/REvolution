module TopModule (
    input in1,
    input in2,
    output out
);
    // Directly instantiate the nor primitive for best area and power
    nor (out, in1, in2);
endmodule