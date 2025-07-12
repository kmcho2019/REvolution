module TopModule(
    input  in1,
    input  in2,
    output out
);
    
    assign out = ~(in1 | in2);  // NOR operation using NOT and OR operators
    
    // Alternatively, you can use the NOR operator directly
    // assign out = in1 nor in2;

endmodule