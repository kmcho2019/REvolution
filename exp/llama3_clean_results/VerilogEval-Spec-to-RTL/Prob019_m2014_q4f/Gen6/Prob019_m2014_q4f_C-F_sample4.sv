module TopModule(
    input  in1,
    input  in2,
    output out
);

// Straightforward implementation of the required logic
assign out = in1 & (~in2);

// For potential exploration of different synthesis paths, an alternative could be:
// assign out = ~(~in1 | in2); // Using De Morgan's Law

endmodule