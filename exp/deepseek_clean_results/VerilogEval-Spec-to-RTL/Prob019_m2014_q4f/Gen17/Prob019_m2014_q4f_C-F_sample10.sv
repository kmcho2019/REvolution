module TopModule (
    input in1,
    input in2,
    output out
);
    // Clear expression of in1 AND (NOT in2) using bitwise operators
    assign out = in1 & ~in2;
endmodule