module TopModule(
    input  a,
    input  b,
    output out
);

assign out = ~(a ^ b); // Using bitwise XOR and then inverting the result

// Alternatively, you can use the equality operator
// assign out = (a == b) ? 1'b1 : 1'b0;

endmodule