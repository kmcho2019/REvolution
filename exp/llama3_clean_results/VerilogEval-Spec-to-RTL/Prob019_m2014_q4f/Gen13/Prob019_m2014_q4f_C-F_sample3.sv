module TopModule(
    input  in1,
    input  in2,
    output out
);
    
// Continuous assignment to implement the AND gate with inverted input
assign out = in1 & ~in2;

endmodule