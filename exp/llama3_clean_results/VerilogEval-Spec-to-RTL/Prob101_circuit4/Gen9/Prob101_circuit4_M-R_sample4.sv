module TopModule(
    input  logic a,
    input  logic b,
    input  logic c,
    input  logic d,
    output logic q
);

// Using a continuous assignment with a conditional operator
// The output q is 1 whenever b or c is 1, regardless of the values of a and d
assign q = (b || c) ? 1'b1 : 1'b0;

endmodule