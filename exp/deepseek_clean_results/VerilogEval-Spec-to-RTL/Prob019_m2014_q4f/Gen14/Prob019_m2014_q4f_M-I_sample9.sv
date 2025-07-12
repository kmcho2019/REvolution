module TopModule (
    input in1,
    input in2,
    output out
);
    // Optimal implementation - cannot be improved further
    assign out = in1 & ~in2;
endmodule