module TopModule(
    input a,
    input b,
    input c,
    output out
);

// Implement the logic using a continuous assignment with a conditional operator and directly expressing the output in terms of the inputs.
assign out = (a || b || c)? 1'b1 : 1'b0;

// Alternatively, we can also use the following implementation, which is more similar to the second example:
// assign out = (a) | (b & c) | (b & ~c) | (~b & c);

endmodule