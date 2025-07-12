module TopModule(
    input in1,
    input in2,
    output out
);
    
    // Utilize the property A & ~B = ~(A | B) to potentially reduce power consumption
    assign out = ~(in1 | in2);

endmodule