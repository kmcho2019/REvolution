// Define a module for a 3-input NAND gate
module nand3(input a, input b, input c, output y);
    assign y = ~(a & b & c);
endmodule

// Define a module for a 2-input NAND gate
module nand2(input a, input b, output y);
    assign y = ~(a & b);
endmodule

// Define the TopModule
module TopModule(
    input p1a,
    input p1b,
    input p1c,
    input p1d,
    input p1e,
    input p1f,
    input p2a,
    input p2b,
    input p2c,
    input p2d,
    output p1y,
    output p2y
);

    // Instantiate NAND gates for p1y
    wire nand1, nand2;
    nand3 nand_gate1(p1a, p1b, p1c, nand1);
    nand3 nand_gate2(p1d, p1e, p1f, nand2);

    // Use NAND to perform OR operation for p1y
    assign p1y = ~(nand1 & nand2);

    // Instantiate NAND gates for p2y
    wire nand3, nand4;
    nand2 nand_gate3(p2a, p2b, nand3);
    nand2 nand_gate4(p2c, p2d, nand4);

    // Use NAND to perform OR operation for p2y
    assign p2y = ~(nand3 & nand4);

endmodule