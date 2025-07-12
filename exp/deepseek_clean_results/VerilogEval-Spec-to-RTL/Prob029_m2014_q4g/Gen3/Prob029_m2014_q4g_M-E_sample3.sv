module TopModule (
    input  in1,
    input  in2,
    input  in3,
    output out
);

    // First stage: XNOR implementation (A·B + ~A·~B)
    wire and_ab, and_nanb;
    wire xnor_out;
    
    assign #1 and_ab = in1 & in2;
    assign #1 and_nanb = ~in1 & ~in2;
    assign #1 xnor_out = and_ab | and_nanb;
    
    // Second stage: XOR implementation (A·~B + ~A·B)
    wire and_anb, and_na;
    assign #1 and_anb = xnor_out & ~in3;
    assign #1 and_na = ~xnor_out & in3;
    assign #1 out = and_anb | and_na;

endmodule