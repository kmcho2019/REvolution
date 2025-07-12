module TopModule (
    input in1,
    input in2,
    output out
);
    // Implements in1 AND (NOT in2) - bubble indicates in2 inversion
    assign out = in1 & ~in2;
endmodule