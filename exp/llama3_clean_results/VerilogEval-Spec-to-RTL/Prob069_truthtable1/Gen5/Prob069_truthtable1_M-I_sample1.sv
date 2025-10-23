module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

// The existing expression is already quite minimal and directly implements the required logic.
assign f = (x2 & ~x3) | (x1 & x3);

// To potentially reduce power consumption, we could consider input patterns or conditions
// under which parts of the circuit could be gated off. However, given the simplicity and
// the combinational nature of the circuit, such optimizations might not be applicable here.

endmodule