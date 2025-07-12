module TopModule (
    input in1,
    input in2,
    output out
);
    assign out = in1 & ~in2;  // Optimal implementation: in1 AND (NOT in2)
endmodule