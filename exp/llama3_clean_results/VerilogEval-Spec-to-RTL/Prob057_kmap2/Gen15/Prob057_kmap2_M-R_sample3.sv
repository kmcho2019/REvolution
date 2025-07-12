module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Define a wire for each term in the simplified expression
wire term1, term2, term3;

// Implement each term using a separate assign statement
assign term1 = ~c & ~d;
assign term2 = b & ~c;
assign term3 = a & d;

// Combine the terms using a single assign statement
assign out = term1 | term2 | term3;

endmodule