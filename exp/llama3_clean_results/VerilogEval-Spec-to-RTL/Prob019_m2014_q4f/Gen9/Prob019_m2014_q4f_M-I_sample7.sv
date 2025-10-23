module TopModule(
    input in1,
    input in2,
    output out
);

// Using a NAND gate followed by a NOT gate to achieve the AND operation with one inverted input
nand nand_gate(nand_out, in1, in2); // Perform NAND operation
not inv_nand_out(out, nand_out); // Invert the NAND output to get the AND operation with one input inverted

endmodule