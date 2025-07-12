// Refactored solution using a simple logical OR operation.
module TopModule(
    input a,
    input b,
    input c,
    output out
);

// Directly implement the logic using a simple OR operation.
assign out = a | b | c;

endmodule