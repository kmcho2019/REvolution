module TopModule(
    input  in1,
    input  in2,
    output out
);

// Direct implementation using logical operators
assign out = in1 & (~in2);

// Alternatively, for exploration of different synthesis paths, we could express it as:
// assign out = ~(~in1 | in2); // De Morgan's Law application

endmodule