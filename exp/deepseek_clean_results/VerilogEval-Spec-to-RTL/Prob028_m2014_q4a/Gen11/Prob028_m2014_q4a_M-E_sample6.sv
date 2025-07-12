module TopModule (
    input d,
    input ena,
    output q
);

wire nand1_out, nand2_out, nand3_out;

// Input control NAND
nand U1 (nand1_out, d, ena);

// Feedback NAND
nand U2 (nand2_out, nand1_out, nand3_out);

// Output NAND (forms the latch with feedback)
nand U3 (nand3_out, nand2_out, ena);

// Final output buffer
buf U4 (q, nand2_out);

endmodule