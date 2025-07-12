module TopModule (
    input  in1,
    input  in2,
    output out
);

// Implement out = in1 AND (NOT in2)
// This models an AND gate with the second input (in2) inverted (bubble on in2)
assign out = in1 & ~in2;

endmodule