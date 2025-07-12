module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

// The current implementation is already optimal in terms of logic simplicity.
// The use of XOR operations directly implements the required functionality without
// needing intermediate variables or more complex logic, which should help in
// minimizing area and potentially power consumption due to reduced switching activity.
assign out = (a ^ b) ^ (c ^ d);

endmodule