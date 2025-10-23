// Given the simplicity and directness of the original implementation, and without specific synthesis directives or attributes to apply,
// the original code is already quite optimized for the task at hand.
module TopModule(
    input a,
    input b,
    input c,
    output out
);

assign out = a? 1'b1 : (b | c);

endmodule