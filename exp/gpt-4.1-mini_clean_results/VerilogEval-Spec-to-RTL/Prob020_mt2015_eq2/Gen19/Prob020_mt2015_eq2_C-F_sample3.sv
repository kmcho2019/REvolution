module TopModule (
    input  [1:0] A,
    input  [1:0] B,
    output       z
);

// Combinational equality comparator using built-in equality operator.
// Synthesis tools will infer minimal XNOR + AND logic internally.
assign z = (A == B);

endmodule