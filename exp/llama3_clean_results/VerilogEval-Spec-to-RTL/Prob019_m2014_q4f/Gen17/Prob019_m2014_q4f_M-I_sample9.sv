module TopModule(
    input  in1,
    input  in2,
    output out
);

// Explicitly define the inversion operation
wire inverted_in2;
assign inverted_in2 = ~in2;

// Use the inverted input in the AND operation
assign out = in1 & inverted_in2;

endmodule