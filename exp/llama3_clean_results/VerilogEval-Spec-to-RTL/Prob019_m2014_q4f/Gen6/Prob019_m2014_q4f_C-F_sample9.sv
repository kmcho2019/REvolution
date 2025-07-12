module TopModule(
    input  in1,
    input  in2,
    output out
);

// Straightforward implementation of the required logic
assign out = in1 & (~in2);

// Alternative implementation using De Morgan's Law for potential synthesis path exploration
// assign out = ~(~in1 | in2);

endmodule