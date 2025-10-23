module TopModule (
    input in1,
    input in2,  // This input is inverted before AND operation
    output out
);
    assign out = in1 & ~in2;  // Equivalent to in1 AND (NOT in2)
endmodule