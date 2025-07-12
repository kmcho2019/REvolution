module TopModule (
    input a,
    input b,
    input sel,
    output out
);
    // Implement 2-to-1 mux using conditional operator
    // More concise while maintaining same functionality
    assign out = sel ? b : a;
endmodule