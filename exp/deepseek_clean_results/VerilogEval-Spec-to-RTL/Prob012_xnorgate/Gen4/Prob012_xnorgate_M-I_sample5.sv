// Optimal implementation (same as original)
module TopModule (
    input a,
    input b,
    output out
);
    assign out = a ~^ b;  // Most direct and clean implementation
endmodule

// Alternative implementation 1: Using equality operator
/*
module TopModule (
    input a,
    input b,
    output out
);
    assign out = (a == b);  // Functionally equivalent
endmodule
*/

// Alternative implementation 2: Structural implementation
/*
module TopModule (
    input a,
    input b,
    output out
);
    wire xor_out;
    assign xor_out = a ^ b;
    assign out = ~xor_out;  // XNOR is NOT of XOR
endmodule
*/