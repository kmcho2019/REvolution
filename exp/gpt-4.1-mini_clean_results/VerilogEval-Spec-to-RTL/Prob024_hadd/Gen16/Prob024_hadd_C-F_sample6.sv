module TopModule (
    input  wire a,
    input  wire b,
    output wire sum,
    output wire cout
);

// Direct instantiation of XOR and AND gate primitives (behavior depends on synthesis tool support).
// These primitives represent minimal gate-level logic without extra module overhead.

// Sum as XOR gate primitive
xor (sum, a, b);

// Carry out as AND gate primitive
and (cout, a, b);

endmodule