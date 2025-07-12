module TopModule (
    input  in1,
    input  in2,
    output out
);
    // Create an explicit wire for the inverted in2, representing the bubble
    wire not_in2 = ~in2;

    // Assign the output as AND of in1 and inverted in2
    assign out = in1 & not_in2;

endmodule