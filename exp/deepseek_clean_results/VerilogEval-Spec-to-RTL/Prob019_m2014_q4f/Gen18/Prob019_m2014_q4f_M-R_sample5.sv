module TopModule (
    input in1,
    input in2,
    output out
);
    wire in2_not;  // Intermediate signal for inverted in2
    
    // Explicit inversion and AND operations
    assign in2_not = ~in2;
    assign out = in1 & in2_not;
endmodule