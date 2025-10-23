// Given the current implementation is already quite efficient, 
// we will focus on minor adjustments to the code to maintain readability and consistency.

module TopModule(
    input  logic a,
    input  logic b,
    input  logic c,
    input  logic d,
    output logic q
);

// The current expression is already quite efficient, 
// but we can consider alternative expressions that achieve the same result.

assign q = ~(a ^ b ^ c ^ d);

endmodule