module TopModule(
    input a,
    input b,
    output out
);
    // Internal wire for NAND output
    wire nand_out;
    
    // Supply rails
    supply1 vdd;
    supply0 gnd;
    
    // CMOS NAND gate implementation
    pmos p1(nand_out, vdd, a);
    pmos p2(nand_out, vdd, b);
    nmos n1(nand_out, gnd, a);
    nmos n2(nand_out, gnd, b);
    
    // CMOS inverter to complete the AND function
    pmos p3(out, vdd, nand_out);
    nmos n3(out, gnd, nand_out);
endmodule