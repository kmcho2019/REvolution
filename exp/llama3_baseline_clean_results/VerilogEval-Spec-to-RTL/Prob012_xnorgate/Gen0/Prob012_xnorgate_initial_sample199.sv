module TopModule(
    input a,
    input b,
    output out
);

assign out = ~(a ^ b); // Using the XOR operator and then inverting the result

endmodule