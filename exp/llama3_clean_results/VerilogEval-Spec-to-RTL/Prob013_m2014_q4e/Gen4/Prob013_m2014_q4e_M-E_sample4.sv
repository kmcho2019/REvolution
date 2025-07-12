module TopModule(in1, in2, out);
    output out;
    input in1, in2;
    wire not_in1, not_in2, and_result;
    
    // Invert the inputs
    assign not_in1 = ~in1;
    assign not_in2 = ~in2;
    
    // Perform the AND operation on the inverted inputs
    assign and_result = not_in1 & not_in2;
    
    // Invert the result to obtain the NOR output
    assign out = ~and_result;
endmodule