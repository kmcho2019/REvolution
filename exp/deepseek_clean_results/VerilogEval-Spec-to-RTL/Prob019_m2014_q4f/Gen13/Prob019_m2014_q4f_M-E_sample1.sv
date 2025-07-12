module TopModule (
    input in1,
    input in2,
    output out
);
    // Implement AND-with-inverted-in2 using a 2:1 mux
    // When in1=0: output is 0 (AND false)
    // When in1=1: output is ~in2 (AND with inverted input)
    assign out = in1 ? ~in2 : 1'b0;
endmodule