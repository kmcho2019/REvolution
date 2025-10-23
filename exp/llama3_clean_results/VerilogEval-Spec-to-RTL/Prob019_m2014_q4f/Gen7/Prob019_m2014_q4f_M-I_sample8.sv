module TopModule(
    input in1,
    input in2,
    output out
);

// Explicitly inverting in2 before applying to the AND gate
wire inverted_in2;
assign inverted_in2 = ~in2;

assign out = in1 & inverted_in2;

endmodule