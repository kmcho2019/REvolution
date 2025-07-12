module TopModule (
    input  [1:0] A,
    input  [1:0] B,
    output       z
);
    wire bit_eq1, bit_eq0;
    wire bitwise_eq;

    // Explicit bitwise equality signals using XNOR gates
    assign bit_eq1 = ~(A[1] ^ B[1]);
    assign bit_eq0 = ~(A[0] ^ B[0]);

    // Combine bitwise equalities
    assign bitwise_eq = bit_eq1 & bit_eq0;

    // Final output using built-in equality operator for synthesis optimization
    assign z = (A == B);
endmodule