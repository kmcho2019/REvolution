module TopModule(
    input in1,
    input in2,
    output out
);
    
    // Directly assign the output of an AND gate with one inverted input to 'out'
    assign out = in1 & ~in2;

endmodule