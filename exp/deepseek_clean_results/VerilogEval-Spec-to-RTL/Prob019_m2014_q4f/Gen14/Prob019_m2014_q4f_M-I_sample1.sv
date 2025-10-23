module TopModule (
    input in1,
    input in2,
    output out
);
    // Optimal implementation of in1 AND NOT in2
    assign out = in1 & ~in2;
endmodule