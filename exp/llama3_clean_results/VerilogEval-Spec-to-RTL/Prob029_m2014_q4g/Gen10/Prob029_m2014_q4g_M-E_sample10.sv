module TopModule(
    input  in1,
    input  in2,
    input  in3,
    output out
);

// Implement the logic based on the truth table analysis
// The XNOR of in1 and in2 can be represented as ~(in1 ^ in2)
// The XOR of this result with in3 gives the final output
// This can be simplified into a single expression
assign out = ~(in1 ^ in2) ^ in3;

// Alternatively, to demonstrate a different architectural approach, 
// we could use a lookup table or a case statement to directly implement the truth table
// However, for simplicity and efficiency, the above assign statement is preferred

endmodule