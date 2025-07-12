module TopModule(
    input  a,
    input  b,
    output out
);

assign out = ~(a ^ b); // Using XOR and then inverting the result
// Alternative approach: assign out = (a == b); // Using equality operator

endmodule