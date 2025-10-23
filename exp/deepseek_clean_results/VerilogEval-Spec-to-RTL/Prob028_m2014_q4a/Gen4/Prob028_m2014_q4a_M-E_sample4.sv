module TopModule (
    input d,
    input ena,
    output q
);

wire nand1_out, nand2_out, nand3_out;

// Input conditioning
nand nand1(nand1_out, d, ena);
nand nand2(nand2_out, ~d, ena);

// Cross-coupled NAND gates for storage
nand nand3(nand3_out, nand1_out, q_bar);
nand nand4(q_bar, nand2_out, nand3_out);

assign q = ~q_bar;

endmodule