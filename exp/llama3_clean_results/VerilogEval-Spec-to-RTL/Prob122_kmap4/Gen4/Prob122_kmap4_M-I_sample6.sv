module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

// Directly implementing the logic without intermediate assignments
// keeps the code concise and efficient.
assign out = (a ^ b) ^ (c ^ d);

// Consider adding synthesis directives or constraints to optimize
// for specific PPA metrics, depending on the synthesis tool being used.

endmodule