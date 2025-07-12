module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);
    // Optimal implementation using bitwise XNOR and AND
    assign z = (A == B);  // This synthesizes to the same optimal gate-level implementation
endmodule