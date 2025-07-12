module TopModule (
    input a,
    input b,
    output out_assign,
    output out_alwaysblock
);
    // Direct primitive AND gate implementation for assign
    and and_gate(out_assign, a, b);
    
    // Custom AND implementation using NAND + NOT for always block
    reg out_reg;
    wire nand_out;
    
    nand nand_gate(nand_out, a, b);
    not not_gate(out_reg, nand_out);
    
    assign out_alwaysblock = out_reg;
endmodule