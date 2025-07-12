module TopModule(
    input a,
    input b,
    input c,
    output out
);

// The direct OR operation is already minimal in terms of logic.
// However, we ensure that the output is driven with the least possible delay,
// considering the synthesis tool's ability to optimize the circuit.
assign out = a | b | c;

endmodule