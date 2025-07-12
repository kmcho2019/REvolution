module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);
    // Maintain optimal implementation - direct equality comparison
    assign z = (A == B);
endmodule