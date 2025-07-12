module TopModule (
    input  in1,
    input  in2,
    output out
);

// Implement AND gate with a bubble (inversion) on in2 input
// out = in1 AND (NOT in2)
// Using continuous assignment for minimal and efficient combinational logic
assign out = in1 & ~in2;

endmodule