module TopModule (
    input a,
    input b,
    output out_and,
    output out_or,
    output out_xor,
    output out_nand,
    output out_nor,
    output out_xnor,
    output out_anotb
);

    // AND gate using MUX
    assign out_and = (a & b) ? 1'b1 : 1'b0;
    
    // OR gate using MUX
    assign out_or = (a | b) ? 1'b1 : 1'b0;
    
    // XOR gate using MUX
    assign out_xor = (a ^ b) ? 1'b1 : 1'b0;
    
    // NAND gate using MUX
    assign out_nand = ~(a & b) ? 1'b1 : 1'b0;
    
    // NOR gate using MUX
    assign out_nor = ~(a | b) ? 1'b1 : 1'b0;
    
    // XNOR gate using MUX
    assign out_xnor = ~(a ^ b) ? 1'b1 : 1'b0;
    
    // A AND NOT B gate using MUX
    assign out_anotb = (a & ~b) ? 1'b1 : 1'b0;

endmodule