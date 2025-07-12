module TopModule(
    input a,
    input b,
    input c,
    output out
);

// Using the ternary operator to conditionally select between a constant 1 and the OR of b and c
assign out = a ? 1'b1 : (b | c);

endmodule