module TopModule(
    input a,
    input b,
    output out
);

// Instantiate built-in and gate primitive
and and_gate_inst (out, a, b);

endmodule