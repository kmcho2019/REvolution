module TopModule (
    input  wire a,
    input  wire b,
    output wire sum,
    output wire cout
);

// Instantiate built-in XOR and AND gates directly
xor xor_gate_inst (sum, a, b);
and and_gate_inst (cout, a, b);

endmodule