module TopModule (
    input wire a,
    input wire b,
    output wire out
);

wire nand1, nand2, nand3, nand4;

// XOR implemented using NAND gates:
// xor = (a NAND b) NAND ( (a NAND a) NAND (b NAND b) )
assign nand1 = ~(a & b);
assign nand2 = ~(a & a); // equivalent to ~a
assign nand3 = ~(b & b); // equivalent to ~b
assign nand4 = ~(nand2 & nand3);
wire xor_out = ~(nand1 & nand4);

// XNOR is NOT XOR, so invert xor_out using a NAND gate
assign out = ~(xor_out & xor_out);

endmodule