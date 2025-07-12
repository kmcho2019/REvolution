module TopModule(
    input  in1,
    input  in2,
    output out
);
    // Internal signals for inverted inputs
    wire inv_in1, inv_in2;
    
    // Invert the inputs
    assign inv_in1 = ~in1;
    assign inv_in2 = ~in2;
    
    // Use a 2-to-1 MUX to select between the inverted inputs
    // The select line is driven by in1
    assign out = in1 ? inv_in2 : inv_in1;
endmodule