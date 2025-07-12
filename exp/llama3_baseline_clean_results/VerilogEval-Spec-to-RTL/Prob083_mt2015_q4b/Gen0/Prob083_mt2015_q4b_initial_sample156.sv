module TopModule(
    input x,
    input y,
    output z
);
    assign z = ~(x ^ y); // using the XOR operator (^) and then inverting the result
endmodule