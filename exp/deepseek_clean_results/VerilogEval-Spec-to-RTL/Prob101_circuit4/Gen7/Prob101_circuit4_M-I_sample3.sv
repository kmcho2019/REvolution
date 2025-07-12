module TopModule (
    input b,       // First input to OR gate
    input c,       // Second input to OR gate
    output q       // Output: b OR c
);

    // Simple OR gate implementation
    assign q = b | c;

endmodule