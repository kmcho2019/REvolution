module TopModule (
    input in1,      // First input signal
    input in2,      // Second input signal (will be inverted)
    output out      // Output: in1 AND (NOT in2)
);
    // Implement AND gate with in2 inverted (bubble on in2 input)
    assign out = in1 & ~in2;
endmodule