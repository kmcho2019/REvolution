module TopModule(
    input  in1,
    input  in2,
    output out
);
    
    // Explicitly invert in2 for potential optimization by the synthesis tool
    wire inverted_in2;
    assign inverted_in2 = ~in2;
    
    // Directly assign the result of the AND operation to out
    assign out = in1 & inverted_in2;

endmodule