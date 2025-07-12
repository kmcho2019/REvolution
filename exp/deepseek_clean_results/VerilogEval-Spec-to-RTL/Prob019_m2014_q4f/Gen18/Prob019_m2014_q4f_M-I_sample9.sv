module TopModule (
    input in1,
    input in2,
    output out
);
    // Direct implementation of AND with inverted in2
    assign out = ~in2 & in1;
endmodule