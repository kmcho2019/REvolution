module TopModule(
    input in1,
    input in2,
    output out
);

not inv_in2(in2_inv, in2); // Invert in2
and and_gate(out, in1, in2_inv); // AND in1 with inverted in2

endmodule