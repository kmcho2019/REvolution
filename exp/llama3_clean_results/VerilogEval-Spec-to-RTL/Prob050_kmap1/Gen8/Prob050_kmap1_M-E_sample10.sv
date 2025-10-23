module TopModule(
    input a,
    input b,
    input c,
    output logic out
);

// Implement the logic using a combination of AND and OR gates
logic term1, term2, term3;

// Term 1: a
assign term1 = a;

// Term 2: b & c
assign term2 = b & c;

// Term 3: b & ~c or ~b & c
assign term3 = (b & ~c) | (~b & c);

// Combine the terms using OR operations
assign out = term1 | term2 | term3;

endmodule